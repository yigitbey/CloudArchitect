extends "res://Server.gd"

signal backend_config_changed

export var backend_config = []

func vars():
	dns_prefix = "loadbalancer_"
	$CollisionShape2D/AnimatedSprite.animation = "LoadBalancer"

func init(level, servers, all):
	vars()
	.init(level, servers, all)
	
func _on_BackendConfig_text_changed():
	backend_config = $ConfigWindow/Servers/BackendConfig.text.split('\n')
	emit_signal("backend_config_changed")
	
func get_response(req):
	var r = request(req)
	return_response(r)
	
func request(original_req):

	var server = backend_config[randi() % backend_config.size()]
	var level = get_parent()
	
	var req = Request.instance()
	req.init(original_req,level.nav_map, level.objects[server], 1000)

	level.add_child(req)
	req.set_process(true)
	
	return req

