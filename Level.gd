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
export var money = 130 setget set_money
export var wave_income = 0
export var game_over = true

export var wave = 0

var messages = []
var waves = {}
var objects = {}

export var dns_record: String
var week_timer: Timer

func _ready():
	connect_signals()
	
	objects = load("res://src/objects.gd")
	objects = JSON.parse(objects.json).result
	waves = objects['waves']
	week_timer = $WeekTimer
	week_timer.wait_time = objects['week']['duration']
	
func _process(_delta):
	pass
	
func connect_signals():
	$HUD.connect("user_request", self, "new_user_request")
	$HUD.connect("new_wave", self, "new_wave")
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
	request.data = "GET /"
	request.set_origin(user)
	request.route.append(user.eth0.ip)
	request.route.append(dns_record)
	
	request.is_malicious = is_malicious
	
	request.send(req_speed)


func set_money(val):
	if val < 0:	
		game_over = true
		$HUD/GameOver.blocking_popup_centered()
	
	
	if money < val:
		wave_income += val - money
	money = val

func new_wave():		
	money -= product_cost
	wave += 1
	wave_income = 0
	product_cost = product_cost_base * wave
	
	
	if wave >= waves.size():
		for i in range(0,30*wave):
				var timer = get_tree().create_timer(0.01+(100-wave)/1000)
				yield(timer, "timeout")
				var is_malicious = false
				if randf() < 0.08:
					is_malicious = true
				new_user_request(is_malicious)
	else:
		var w = waves[str(wave)]
		for speed in ['slow', 'med', 'fast']:
			for i in range(0,w['requests'][speed]):
					var timer = get_tree().create_timer(w['time_between_requests'])
					yield(timer, "timeout")
					var is_malicious = false
					if randf() < w['requests']['malicious']:
						is_malicious = true
					new_user_request(is_malicious)
			


func _on_WeekTimer_timeout():
	if !$WeekTimer.one_shot:
		new_wave()
