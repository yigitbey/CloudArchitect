extends "res://Server.gd"

export var initial_cost = 50

export var db: String

func vars():
	$CollisionShape2D/AnimatedSprite.animation = "DynamicServer"

func _init():
	vars()

func _on_DatabaseConfig_text_changed():
	db = $ConfigWindow/Database/DatabaseConfig.text

#move this to Server and override it
func process_request(req):
	if req.response:
		req.route.pop_back()
	else:
		req.route.append(db)
		
	yield(calculate_response_time(), "completed")
	
	req.send(100)

	var response =	yield(req, 'processed')

		
	return response
	
