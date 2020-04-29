extends Node2D

onready var nav_map = $Navigation2D

var StaticServer = preload("res://StaticServer.tscn")
var Request = preload("res://Request.tscn")
var LoadBalancer = preload("res://LoadBalancer.tscn")
var User = preload("res://User.tscn")
var Packet = preload("res://src/Packet.gd")

var iptable = {}
export var money = 0
var infra_types = [StaticServer, LoadBalancer]


export var dns_record = "static_0"

func _ready():
	connect_signals()

func connect_signals():
	$HUD.connect("user_request", self, "new_user_request")
	$HUD.connect('dns_change', self, 'set_dns_record')
	$HUD.connect('new_staticserver', self, 'new_instance', [StaticServer])
	$HUD.connect('new_lb', self, 'new_instance', [LoadBalancer])

func new_instance(obj):
	var new = obj.instance()
	add_child(new)
	new.init2()
	return new

func set_dns_record():
	dns_record = $HUD.dns_record

func new_user_request():
	var user = new_instance(User)	
	var request = new_instance(Request)

	var data = "GET /"
	var packet = Packet.new()
	packet.init(user.eth0.ip, data, dns_record)
	request.packet = packet
	request.send()

