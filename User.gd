extends KinematicBody2D

const Interface = preload("src/Interface.gd")

var eth0: Interface
var level: Node2D
export var entry_position = Vector2(64,648)

var speeds = {'slow':100, 'med':250, 'fast': 500}

#TODO: clear if user.request is already freed (request timed out)
func _init():
	eth0 = Interface.new()
	
func init2():
	level = get_parent()
	position = entry_position

	level.iptable[eth0.ip] = self

func _ready():
	pass

func get_response(req):
	var level = get_parent()
	level.money += req.money

	print ('request successful:' + req.response)
	
	req.queue_free()
	queue_free()
