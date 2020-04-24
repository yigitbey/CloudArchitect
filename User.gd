extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_response(req):
	var level = get_parent()
	level.money = level.money + 10

	print ('request successful')
	
	req.queue_free()
	queue_free()
