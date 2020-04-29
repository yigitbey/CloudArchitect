extends Node2D

signal arrived

var speed = 400
var path = []
var destination = Node
var origin = Node2D
var at_target = false
var packet = preload("src/Packet.gd")
var level = Node2D

func init2():
	level = get_parent()

func _ready():
	set_animation("NE")
	set_process(false)

func set_animation(anim):
	$AnimatedSprite.animation = anim

func _process(delta):
	var move_distance = speed * delta
	move_along_path(move_distance)
	
	if path.size() == 0 and not at_target:
		arrived()

func arrived():
	at_target = true
	set_process(false)
	destination.get_response(self)
	
func back():
	var swp = destination
	destination = origin
	origin = swp
	
func send(speed=100):
	origin = level.iptable[packet.origin]
	destination = level.iptable[packet.destination]
	position = origin.position
	
	pathfind(level.nav_map)
	
	at_target = false
	set_process(true)
	
func pathfind(map):
	path = map.get_simple_path(global_position, destination.global_position, false)

func move_along_path(distance):
	var start = position
	
	for _i in range(path.size()):
		choose_animation(path[0])
		var distance_to_next = start.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		distance -= distance_to_next
		start = path[0]
		path.remove(0)
	
func choose_animation(target):
	var direction = target - global_position
	if direction.x > 0 and direction.y > 0:
		$AnimatedSprite.animation = "SE"
	if direction.x > 0 and direction.y < 0:
		$AnimatedSprite.animation = "NE"
	if direction.x < 0 and direction.y > 0:
		$AnimatedSprite.animation = "SW"
	if direction.x < 0 and direction.y < 0:
		$AnimatedSprite.animation = "NW"	
	

