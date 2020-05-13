extends KinematicBody2D


const Request = preload("res://Request.tscn")
const Interface = preload("src/Interface.gd")

var can_grab = false
var grabbed_offset = Vector2()
var eth0: Interface
var level: Node2D
var callback: Object
var ports = {}
var sysload: float
var type: String
var properties = {}
var server_name: String
var cpu = 1
const cpu_max = 64
var instance_family = "m4-standard"
var instance_size: String
var config_warning: bool = false

func init2():
	instance_size = instance_family + "-" + str(cpu)
	$CollisionShape2D/AnimatedSprite.animation = type
	level = get_parent()
	var margin = level.iptable.size()*30
	position = Vector2(200+margin, 200+margin)
	
	eth0 = Interface.new()
	level.iptable[eth0.ip] = self

	server_name = eth0.ip
	$Meta/ConfigWindow/Info/Name.text = server_name
	$Meta/ConfigWindow/Info/IP.text = server_name
	$Meta/ConfigWindow/Info/InstanceSize.text = instance_size

	
func _ready():
	$Meta/ConfigWindow.visible = false
	
	var objects = load("res://src/objects.gd")
	objects = JSON.parse(objects.json).result
	properties = objects['entities'][type]

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			can_grab = event.pressed
			grabbed_offset = position - get_global_mouse_position()
		if event.button_index == 2 and !event.is_pressed():
			level.iptable.erase(eth0.ip)
			queue_free()

func _process(_delta):	
	$Meta/DNSNameLabel.text = server_name
	$Meta/SysLoadBar.value = sysload
	$Meta/ConfigWindow/Info/InstanceSize.text = instance_size
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset
		
	if sysload <= 0.5:
		$CollisionShape2D.modulate = Color(1,1,1,1)
	if sysload > 0.5 and sysload < 0.9:
		$CollisionShape2D.modulate = Color(1,0.5,0)
	if sysload >= 0.9:
		$CollisionShape2D.modulate = Color(1,0,0)
		
	$Meta/ConfigWindow/Info/Cost.text = str(properties['monthly_cost']*cpu)
	
	if config_warning:
		$Meta/ToggleConfig.modulate = Color(1,0.2,0.2,1)
	else:
		$Meta/ToggleConfig.modulate = Color(1,1,1,1)
		
func get_response(req):
	var response = yield(process_request(req), "completed")

	return_response(req, response)

func return_response(req, response):
	if response: #temp bug workaround
		req.response = req.response + response
		req.send()

func generate_system_load(wait):
	var amount = properties['load_per_request'] / cpu
	
	var duration = (properties['load_per_request'] / cpu)*5 + properties['load_per_request']
	
	sysload = sysload + amount
	duration *= (1+sysload)
	var timer = get_tree().create_timer(wait+duration)
	timer.connect('timeout',self, "end_system_load", [amount])
	
func end_system_load(amount):
	sysload = sysload - amount

func calculate_response_time():
	var wait
	if sysload < 0.9:
		wait = 0.5*sysload
	else:
		wait = 5
	generate_system_load(wait)

	yield(get_tree().create_timer(wait), "timeout")

#should yield
func process_request(req):
	yield(get_tree(), "idle_frame")
	req.route.pop_back()
	req.money += properties['revenue']
	yield(calculate_response_time(), "completed")
	
	return("200 OK")
	
func upgrade():
	cpu *= 2
	var upgrade_cost = properties['monthly_cost']*cpu
	var new = $CollisionShape2D/AnimatedSprite.duplicate()
	new.name = "cpu"+str(cpu)
	new.position[1] = -25*(log(cpu)/log(2))
	$CollisionShape2D.add_child(new)
	instance_size = instance_family + "-" + str(cpu)
	if cpu == cpu_max:
		$Meta/ConfigWindow/Info/UpgradeInstance.disabled = true
	
func _on_ToggleConfig_pressed():
	if $Meta/ConfigWindow.visible:
		$Meta/ConfigWindow.visible = false
		$Meta/ToggleConfig/Icon.icon_name = "wrench"
		$Meta/ToggleConfig/Icon.modulate = Color(0.7,0.7,0.7,1)
	else:
		$Meta/ConfigWindow.visible = true
		$Meta/ToggleConfig/Icon.icon_name = "window-close"
		$Meta/ToggleConfig/Icon.modulate = Color(1,0,0,0.8)


func _on_Name_text_changed(text):
	server_name = text
