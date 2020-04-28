extends KinematicBody2D


const Request = preload("res://Request.tscn")
const Interface = preload("src/Interface.gd")

var can_grab = false
var grabbed_offset = Vector2()
var eth0: Interface

func init(level, all):
	var margin = all.size()*10
	position = Vector2(500+margin, 500+margin)
	
	eth0 = Interface.new()
	all[eth0.ip] = self
	
	level.add_child(self)

func _ready():
	$ConfigWindow.visible = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(delta):
	$DNSNameLabel.text = eth0.ip
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset

func get_response(req):
	request(req)
	return_response(req)

func return_response(req):
	var level = get_parent()
	req.pathfind(level.nav_map, req.origin)

func request(req):
	print('backend_request')
	
func _on_ToggleConfig_pressed():
	if $ConfigWindow.visible:
		$ConfigWindow.visible = false
		$ToggleConfig.text = "Configure"
	else:
		$ConfigWindow.visible = true
		$ToggleConfig.text = "Hide config"
