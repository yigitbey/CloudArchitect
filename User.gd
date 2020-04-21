extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text" 

var speed = 400
var path setget set_path

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

func _process(delta):
	var move_distance = speed * delta
	move_along_path(move_distance)

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
	
func set_path(value):
	path = value
	if value.size() == 0:
		return
	
	set_process(true)
	

