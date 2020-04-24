extends "res://Server.gd"

signal backend_config_changed

export var backend_config = []

func vars():
	dns_prefix = "loadbalancer_"

func init(level, servers, all):
	vars()
	.init(level, servers, all)
	
func _on_BackendConfig_text_changed():
	backend_config = $ConfigWindow/Servers/BackendConfig.text.split('\n')
	emit_signal("backend_config_changed")
	
func request():

	var server = backend_config[randi() % backend_config.size()]
	var level = get_parent()
	
	var req = Request.instance()
	req.speed = 1000
	req.position = position
	level.add_child(req)

	req.pathfind(level.nav_map, level.objects[server])
	req.set_process(true)

	.request()
