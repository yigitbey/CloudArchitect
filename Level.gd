extends Node2D

onready var nav_map = $Navigation2D

const StaticServer =  preload("res://StaticServer.tscn")
const DynamicServer = preload("res://DynamicServer.tscn")
const LoadBalancer = preload("res://LoadBalancer.tscn")
const Database = preload("res://Database.tscn")

const User = preload("res://User.tscn")
const Request = preload("res://Request.tscn")

var iptable = {}

export var money = 20
export var wave = 0
var waves = {}

export var dns_record: String

func _ready():
	connect_signals()
	
	var objects = load("res://src/objects.gd")
	var objects2 = JSON.parse(objects.json).result
	waves = objects2['waves']
	
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
func new_user_request(speed="slow"):
	var user = new_instance("User")	
	var request = new_instance("Request")

	speed = user.speeds[speed]
	request.data = "GET /"
	request.set_origin(user)
	request.route.append(user.eth0.ip)
	request.route.append(dns_record)
	
	request.send(speed)

func new_wave():
	wave += 1
	var w = waves[str(wave)]
	
	for speed in ['slow', 'med', 'fast']:
		
		for i in range(0,w['requests'][speed]):
			var timer = get_tree().create_timer(w['time_between_requests'])
			yield(timer, "timeout")
			new_user_request()
