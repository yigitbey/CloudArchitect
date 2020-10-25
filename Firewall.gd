extends "res://Server.gd"

signal backend_config_changed

export var backend_config = []

func _init():
	type = "Firewall"
	config_warning = true
	accepted_content_types = ['dynamic', 'static']

func _on_BackendConfig_text_changed(text):
	backend_config = text
	if backend_config in level.iptable:
		config_warning = false
		$Meta/ConfigWindow/Backend/BackendConfig.modulate = Color(1,1,1,1)

#move to Server
func process_request(req):
	
	if req.is_malicious:
		req.route.pop_back()
		yield(get_tree(), "idle_frame")
		return "403 Forbidden"
	
	var server = backend_config
	if req.response:
		req.route.pop_back()
	else:
		req.route.append(server)
		
	yield(calculate_response_time(), "completed")
	
	req.send(100)

	var response = yield(req, 'processed')

		
	return response
	
