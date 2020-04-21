extends Node2D

onready var nav_map = $Navigation2D
onready var user = $User
onready var navigation_line = $NavigationLine

var Website = preload("res://Website.tscn")
var websites = []
var objects = {}

export var dns_record = "server_0"

func set_dns_record():
	dns_record = $HUD.dns_record

func pathfind():
	var new_path = nav_map.get_simple_path(user.global_position, objects[dns_record].global_position, false)
	navigation_line.points = new_path
	
	user.path = new_path

func new_website():
	var new = Website.instance()
	new.position = Vector2(50,50)
	var id = websites.size()
	new.dns_name = 'server_' + str(id)

	add_child(new)
	websites.append(new)
	objects[new.dns_name] = new
	

func _ready():
	$HUD.connect("path_find", self, "pathfind")
	$HUD.connect('new_website', self, 'new_website')
	$HUD.connect('dns_change', self, 'set_dns_record')
