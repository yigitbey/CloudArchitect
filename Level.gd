extends Node2D

onready var nav_map = $Navigation2D

const StaticServer =  preload("res://StaticServer.tscn")
const DynamicServer = preload("res://DynamicServer.tscn")
const LoadBalancer = preload("res://LoadBalancer.tscn")
const Database = preload("res://Database.tscn")
const Firewall = preload("res://Firewall.tscn")

const User = preload("res://User.tscn")
const Request = preload("res://Request.tscn")

var iptable = {}

export var product_cost_base = 30
export var product_cost: float
export var money = 250 setget set_money
export var month_income = 0
export var game_over = true
export var server_costs = 0
export var month = 0

var messages = []
var months = {}
var objects = {}

var request_logs = []

export var dns_record: String
var month_timer: Timer

var request_types = ['static', 'dynamic']

func _ready():
	get_tree().paused = false
	randomize()
	connect_signals()
	
	objects = load("res://src/objects.gd")
	objects = JSON.parse(objects.json).result
	months = objects['months']
	month_timer = $MonthTimer
	month_timer.wait_time = objects['month']['duration']
	
func _process(_delta):
	server_costs = calculate_server_cost()
	
func connect_signals():
	$HUD.connect("user_request", self, "new_user_request")
	$HUD.connect("new_month", self, "new_month")
	$HUD.connect('dns_change', self, 'set_dns_record')
	$HUD.connect('new_server', self, 'new_instance')
	$HUD.connect('clear', self, 'clear')

func clear():
	var all = get_tree().get_root().get_child(0).get_children()
	for i in all:
		if i.is_class("User"):
			i.queue_free()
		if i.is_class("Request"):
			i.queue_free()

func new_instance(obj_name):

	var obj = get(obj_name)
	var new = obj.instance()
	add_child(new)
	new.init2()
	return new


func set_dns_record():
	dns_record = $HUD.dns_record

#todo: move this under user
func new_user_request(is_malicious:bool, speed:String="slow"):
	var user = new_instance("User")	
	var request = new_instance("Request")

	var req_speed:int = user.speeds[speed]

	request.type = request_types[randi()%2]
	var potential_urls = objects['request_urls'][request.type]
	request.url = potential_urls[randi()%len(potential_urls)]
	
	if request.type == 'static':
		request.method = 'GET'
	else:
		var methods = ['POST', 'PUT', 'PATCH']
		request.method = methods[randi() % len(methods)]
		
	request.data = request.method + " " + request.url
	#$HUD.add_log(request.data)
	
	request.set_origin(user)
	request.route.append(user.eth0.ip)
	request.route.append(dns_record)
	
	request.is_malicious = is_malicious
	
	request.send(req_speed)

func add_log(msg):
	$HUD.add_log(msg)

func set_money(val):
	if val < 0:	
		game_over = true
		#get_tree().paused = true
		$HUD/GameOver.blocking_popup_centered()
	
	if money < val:
		month_income += val - money
	money = val

func new_month():
	month += 1
	month_income = 0
	product_cost = product_cost_base * month
	server_costs = calculate_server_cost()

	var spread:float = 1/(log(month+1)*log(month+1))	
	while month_timer.time_left:
		var is_malicious = false
		if randf() < objects['requests']['malicious'] and month>=3:
			is_malicious = true
		new_user_request(is_malicious)
		yield(get_tree().create_timer(spread), "timeout")

func calculate_server_cost():
	server_costs = 0
	for s in iptable.values():
		if s.properties['monthly_cost']:
			server_costs += s.properties['monthly_cost']*s.cpu	
	return server_costs
	
func _on_MonthTimer_timeout():
	money -= server_costs + product_cost
	
	if !$MonthTimer.one_shot:
		new_month()
