extends KinematicBody2D

# Pickable needs to be selected from the inspector

var can_grab = false
var grabbed_offset = Vector2()
export var dns_name = ""

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(delta):
	$DNSNameLabel.text = dns_name
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset

func request():
	print('backend_request')
