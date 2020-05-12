extends "res://Server.gd"

signal backend_config_changed

export var backend_config = []

func _init():
	type = "Firewall"

func _on_BackendConfig_text_changed(text):
	backend_config = text

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
	
