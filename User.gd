extends KinematicBody2D

const Interface = preload("src/Interface.gd")
var eth0: Interface

func _init():
	eth0 = Interface.new()
	

func _ready():
	pass

func get_response(req):
	var level = get_parent()
	level.money = level.money + 10

	print ('request successful')
	
	req.queue_free()
	queue_free()
