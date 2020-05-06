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
const cpu_max = 8
var instance_family = "a1-medium"
var instance_size: String

func init2():
	instance_size = instance_family + "-" + str(cpu)
	$CollisionShape2D/AnimatedSprite.animation = type
	level = get_parent()
	var margin = level.iptable.size()*30
	position = Vector2(200+margin, 200+margin)
	
	eth0 = Interface.new()
	level.iptable[eth0.ip] = self

	server_name = eth0.ip
	$ConfigWindow/Info/Name.text = server_name
	$ConfigWindow/Info/IP.text = server_name
	$ConfigWindow/Info/InstanceSize.text = instance_size
	
	level.money -= properties['initial_cost']	
	
func _ready():
	$ConfigWindow.visible = false
	
	var objects = load("res://src/objects.gd")
	objects = JSON.parse(objects.json).result
	properties = objects['entities'][type]

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(_delta):	
	$DNSNameLabel.text = server_name
	$SysLoadBar.value = sysload
	$ConfigWindow/Info/InstanceSize.text = instance_size
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset
		
	if sysload <= 0.5:
		$CollisionShape2D.modulate = Color(1,1,1,1)
	if sysload > 0.5 and sysload < 0.9:
		$CollisionShape2D.modulate = Color(1,0.5,0)
	if sysload >= 0.9:
		$CollisionShape2D.modulate = Color(1,0,0)
		
		
func get_response(req):
	var response = yield(process_request(req), "completed")

	return_response(req, response)

func return_response(req, response):
	req.response = req.response + response
	req.send()

func generate_system_load(wait, amount=0.1, duration=0.1):
	amount /= cpu
	duration /= cpu
	
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
	req.route.pop_back()
	req.money += properties['revenue']
	yield(calculate_response_time(), "completed")
	
	return("200 OK")
	
func upgrade():
	cpu *= 2
	var upgrade_cost = properties['initial_cost']*cpu
	var new = $CollisionShape2D/AnimatedSprite.duplicate()
	new.name = "cpu"+str(cpu)
	new.position[1] = -25*(log(cpu)/log(2))
	$CollisionShape2D.add_child(new)
	level.money -= upgrade_cost
	instance_size = instance_family + "-" + str(cpu)
	if cpu == cpu_max:
		$ConfigWindow/Info/UpgradeInstance.disabled = true
	
func _on_ToggleConfig_pressed():
	if $ConfigWindow.visible:
		$ConfigWindow.visible = false
		$ToggleConfig/Icon.icon_name = "wrench"
		$ToggleConfig/Icon.modulate = Color(0.7,0.7,0.7,1)
	else:
		$ConfigWindow.visible = true
		$ToggleConfig/Icon.icon_name = "window-close"
		$ToggleConfig/Icon.modulate = Color(1,0,0,0.8)


func _on_Name_text_changed(text):
	server_name = text
