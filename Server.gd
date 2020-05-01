extends KinematicBody2D


const Request = preload("res://Request.tscn")
const Interface = preload("src/Interface.gd")
const Packet = preload("src/Packet.gd")

var can_grab = false
var grabbed_offset = Vector2()
var eth0: Interface
var level: Node2D
var callback: Object
var ports = {}
var sysload: float

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
	$SysLoadBar.value = sysload
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset

func get_response(req):
#	var port = req.get_instance_id()
#	if ports.get(port):
#		ports[port].append(req)
#	else:
#		ports[port] = [req]
	var response = yield(process_request(req), "completed")
	
	return_response(req, response)

func return_response(req, response):

	#var destination = request.route.pop_back()
	var packet = Packet.new()
#	packet.init(eth0.ip, response, destination.eth0.ip)
#	req.packet = packet
	req.response = req.response + response
	req.send()

func generate_system_load(wait, amount=0.1, duration=3):
	sysload = sysload + amount
	duration = duration*(1+sysload)
	var timer = get_tree().create_timer(wait+duration)
	timer.connect('timeout',self, "end_system_load", [amount])
	
func end_system_load(amount):
	sysload = sysload - amount

func calculate_response_time():
	var wait
	if sysload < 0.9:
		wait = 0.5*sysload
	else:
		wait = 10
	generate_system_load(wait)

	yield(get_tree().create_timer(wait), "timeout")
#should yield
func process_request(req):
	yield(get_tree(), "idle_frame")
	print('backend_request')
	req.route.pop_back()

	yield(calculate_response_time(), "completed")
	
	return("200 OK")
	
func _on_ToggleConfig_pressed():
	if $ConfigWindow.visible:
		$ConfigWindow.visible = false
		$ToggleConfig.text = "Configure"
	else:
		$ConfigWindow.visible = true
		$ToggleConfig.text = "Hide config"
