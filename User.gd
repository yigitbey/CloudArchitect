extends KinematicBody2D

const Interface = preload("src/Interface.gd")

var eth0: Interface
var level: Node2D
export var entry_position = Vector2(64,648)

var speeds = {'slow':100, 'med':250, 'fast': 500}

var normal_response_time = 10
var fast_response_time = 5
var slow_response_time = 30

#TODO: clear if user.request is already freed (request timed out)
func _init():
	eth0 = Interface.new()

	
func init2():
	entry_position[0] += (randi() % 20) - 10
	entry_position[1] += (randi() % 20) - 10
	position = entry_position
	level = get_parent()
	
	#todo: this should be in interface
	while eth0.ip in level.iptable:
		eth0 = Interface.new()
	#

	level.iptable[eth0.ip] = self

func _ready():
	add_to_group("will_pause")

func get_response(req):
	var level = get_parent()
	var rev_multiplier: float
	if req.alive < fast_response_time:
		rev_multiplier = 1.2
	elif req.alive < normal_response_time:
		rev_multiplier = 1
	elif req.alive < slow_response_time:
		rev_multiplier = (30-req.alive)/30
	else:
		rev_multiplier = 0
	
	level.money += req.money * rev_multiplier

	print ('request successful:' + req.response)
	
	#TODO: fix ip collision
	level.iptable.erase(eth0.ip)
	
	
	req.queue_free()
	queue_free()

func pause():
	set_process(false)
	
func resume():
	set_process(true)
