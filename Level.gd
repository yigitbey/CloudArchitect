extends Node2D

onready var nav_map = $Navigation2D

var Website = preload("res://Website.tscn")
var User = preload("res://User.tscn")
var LoadBalancer = preload("res://LoadBalancer.tscn")
var websites = []
var load_balancers = []
var objects = {}
var infra_types = [Website, LoadBalancer]

export var dns_record = "server_0"

func set_dns_record():
	dns_record = $HUD.dns_record




func pathfind():
	var user = User.instance()
	user.position = Vector2(64,648)
	user.connect('arrived', self, "_on_User_arrived", [user])
	add_child(user)
	
	user.pathfind(nav_map, objects[dns_record])



func new_website():
	var new = Website.instance()
	new.position = Vector2(500,50)
	var id = websites.size()
	new.dns_name = 'server_' + str(id)

	add_child(new)
	websites.append(new)
	objects[new.dns_name] = new

func backend_config_changed(lb):
	pass
	

func new_lb():
	var new = LoadBalancer.instance()

	new.position = Vector2(500,50)
	var id = load_balancers.size()
	new.dns_name = 'loadbalancer_' + str(id)

	add_child(new)
	websites.append(new)
	new.connect("backend_config_changed", self, 'backend_config_changed', [new])
	objects[new.dns_name] = new

	

func _ready():
	$HUD.connect("path_find", self, "pathfind")
	$HUD.connect('dns_change', self, 'set_dns_record')
	
	$HUD.connect('new_website', self, 'new_website')
	$HUD.connect('new_lb', self, 'new_lb')
	
	

	
func _on_User_arrived(user):
	print('user_arrived')
	user.destination.request()
