extends "res://Server.gd"

export var db: String

func _init():
	type = "DynamicServer"
	config_warning = true
	accepted_content_types = ['dynamic']	

func _on_DatabaseConfig_text_changed():
	db = $Meta/ConfigWindow/Database/DatabaseConfig.text
	if db in level.iptable:
		config_warning = false
		$Meta/ConfigWindow/Database/DatabaseConfig.modulate = Color(1,1,1,1)

#move this to Server and then override it
func process_request(req):
	if req.response:
		req.route.pop_back()
	else:
		req.route.append(db)
		
	yield(calculate_response_time(), "completed")
	req.money += properties['revenue']
	req.send(100)

	var response =	yield(req, 'processed')

		
	return response
	
