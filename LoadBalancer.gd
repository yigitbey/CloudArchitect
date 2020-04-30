extends "res://Server.gd"

signal backend_config_changed

export var backend_config = []

func vars():
	$CollisionShape2D/AnimatedSprite.animation = "LoadBalancer"

func _init():
	vars()

func _on_BackendConfig_text_changed():
	backend_config = $ConfigWindow/Servers/BackendConfig.text.split('\n')
	emit_signal("backend_config_changed")

func process_request(original_req):

	var server = backend_config[randi() % backend_config.size()]
	
	var req = level.new_instance(Request)
	var packet = Packet.new()
	packet.init(eth0.ip, original_req.packet.data, server)
	req.packet = packet
	req.send(100)
	
	yield()
	
	
