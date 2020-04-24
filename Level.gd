extends Node2D

onready var nav_map = $Navigation2D

var StaticServer = preload("res://StaticServer.tscn")
var Request = preload("res://Request.tscn")
var LoadBalancer = preload("res://LoadBalancer.tscn")
var websites = []
var load_balancers = []
var objects = {}
var infra_types = [StaticServer, LoadBalancer]

export var dns_record = "static_0"

func _ready():
	connect_signals()

func connect_signals():
	$HUD.connect("user_request", self, "new_user_request")
	$HUD.connect('dns_change', self, 'set_dns_record')
	$HUD.connect('new_staticserver', self, 'new_staticserver')
	$HUD.connect('new_lb', self, 'new_lb')

func new_staticserver():
	var new = StaticServer.instance()
	new.init(self, websites, objects)

func new_lb():
	var new = LoadBalancer.instance()
	new.init(self, load_balancers, objects)

func set_dns_record():
	dns_record = $HUD.dns_record

func new_user_request():
	var request = Request.instance()
	request.position = Vector2(64,648)
	request.connect('arrived', self, "_on_request_arrived", [request])
	add_child(request)
	
	request.pathfind(nav_map, objects[dns_record])
	
func _on_request_arrived(request):
	request.destination.request() # create a new request on destination
