extends "res://Server.gd"

signal backend_config_changed

export var backend_config = []

func _init():
	type = "LoadBalancer"

func _on_BackendConfig_text_changed():
	backend_config = $Meta/ConfigWindow/Servers/BackendConfig.text.split('\n')

#move to Server
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
	
