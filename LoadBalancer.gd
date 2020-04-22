extends KinematicBody2D
signal backend_config_changed

# Pickable needs to be selected from the inspector

var can_grab = false
var grabbed_offset = Vector2()
export var dns_name = ""

export var backend_config = []

var Request = preload("res://User.tscn")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(delta):
	$DNSNameLabel.text = dns_name
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset

func _on_BackendConfig_text_changed():
	backend_config = $BackendConfig.text.split('\n')
	emit_signal("backend_config_changed")
	
func request():
	print('lb_request')
	var server = backend_config[randi() % backend_config.size()]
	var level = get_parent()
	
	var req = Request.instance()
	req.speed = 1000
	req.position = position
	level.add_child(req)

	req.pathfind(level.nav_map, level.objects[server])
	req.set_process(true)

