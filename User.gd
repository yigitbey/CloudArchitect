extends KinematicBody2D

const Interface = preload("src/Interface.gd")

var eth0: Interface
var level: Node2D
export var entry_position = Vector2(64,648)

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
	level.money = level.money + 10

	print ('request successful:' + req.packet.data)
	
	req.queue_free()
	queue_free()
