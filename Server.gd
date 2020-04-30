extends KinematicBody2D


const Request = preload("res://Request.tscn")
const Interface = preload("src/Interface.gd")
const Packet = preload("src/Packet.gd")

var can_grab = false
var grabbed_offset = Vector2()
var eth0: Interface
var level: Node2D
var callback: Object

func init2():
	level = get_parent()
	print('server.init2')
	var margin = level.iptable.size()*10
	position = Vector2(500+margin, 500+margin)
	
	eth0 = Interface.new()
	level.iptable[eth0.ip] = self
	
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
	var response = yield(process_request(req), "completed")
	return_response(req, response)

func return_response(req, response):
	var packet = Packet.new()
	packet.init(req.destination.eth0.ip, response, req.origin.eth0.ip)
	req.packet = packet
	#req.packet.data = response
	req.send()

func process_request(req):
	yield(get_tree(), "idle_frame")
	print('backend_request')
	#emit_signal('response_created')
	return("200 OK")
	
func _on_ToggleConfig_pressed():
	if $ConfigWindow.visible:
		$ConfigWindow.visible = false
		$ToggleConfig.text = "Configure"
	else:
		$ConfigWindow.visible = true
		$ToggleConfig.text = "Hide config"
