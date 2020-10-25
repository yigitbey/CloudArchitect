extends "res://Server.gd"

signal backend_config_changed

var backend_config = []
var config = {}

func _init():
	type = "LoadBalancer"
	config_warning = true
	accepted_content_types = ['dynamic', 'static']

func _on_saveButton_pressed():
	_save_config('static_backend_config')
	_save_config('dynamic_backend_config')
	
func _save_config(config_type):
	config[config_type] = $Meta/ConfigWindow/Servers.get_node(config_type).text.split('\n')
	
	if len(config[config_type]):	
		config_warning = false
		
		for b in config[config_type]:
			if not b in level.iptable:
				config_warning = true
		
	if config_warning == false:
		$Meta/ConfigWindow/Servers.get_node(config_type).modulate = Color(1,1,1,1)
		
#move to Server
func process_request(req):
	if req.type == 'dynamic':
		backend_config = config['dynamic_backend_config']
	else:
		backend_config = config['static_backend_config']
	
	var server = backend_config[randi() % backend_config.size()]
	if req.response:
		req.route.pop_back()
	else:
		req.route.append(server)
		
	yield(calculate_response_time(), "completed")
	
	req.send(100)

	var response =	yield(req, 'processed')

		
	return response
	
