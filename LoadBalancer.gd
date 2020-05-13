extends "res://Server.gd"

signal backend_config_changed

export var backend_config = []

func _init():
	type = "LoadBalancer"
	config_warning = true

func _on_BackendConfig_text_changed():
	backend_config = $Meta/ConfigWindow/Servers/BackendConfig.text.split('\n')
	if len(backend_config):	
		config_warning = false
		
		for b in backend_config:
			if not b in level.iptable:
				config_warning = true
		
	if config_warning == false:
		$Meta/ConfigWindow/Servers/BackendConfig.modulate = Color(1,1,1,1)
		
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
	
