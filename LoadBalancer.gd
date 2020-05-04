extends "res://Server.gd"

signal backend_config_changed

export var initial_cost = 50


export var backend_config = []

func vars():
	$CollisionShape2D/AnimatedSprite.animation = "LoadBalancer"

func _init():
	vars()

func _on_BackendConfig_text_changed():
	backend_config = $ConfigWindow/Servers/BackendConfig.text.split('\n')
	emit_signal("backend_config_changed")
	
func process_request(req):
	print('loadbalancer')
	var server = backend_config[randi() % backend_config.size()]
	if req.response:
		req.route.pop_back()
	else:
		req.route.append(server)
		
	yield(calculate_response_time(), "completed")
	
	req.send(100)

	var response =	yield(req, 'processed')

		
	return response
	
