extends KinematicBody2D

const Interface = preload("src/Interface.gd")

var eth0: Interface
var level: Node2D
export var entry_position = Vector2(64,648)

var speeds = {'slow':100, 'med':250, 'fast': 500}

var normal_response_time = 10
var fast_response_time = 5
var slow_response_time = 30

var properties = {}
var type = "User"

var log_format = "%d %s %s Money earned: %.1f"
signal amount_stolen

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

	var objects = load("res://src/objects.gd")
	objects = JSON.parse(objects.json).result
	properties = objects['entities'][type]

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
	
	if req.is_malicious and req.response != "403 Forbidden":
		rev_multiplier *= (randi()%100) * -1
		var amount_stolen = req.money*rev_multiplier
		level.messages.append("Hackers managed to steal $" + str(amount_stolen*-1))
	
	var income = 0
	
	if req.status_code == 200:
		income = req.money * rev_multiplier
		level.money += income
		
	level.add_log(log_format % [req.status_code, req.method, req.url, income])
	
	#TODO: fix ip collision
	level.iptable.erase(eth0.ip)
	
	req.queue_free()
	queue_free()

func pause():
	set_process(false)
	
func resume():
	set_process(true)
