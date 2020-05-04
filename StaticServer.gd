extends "res://Server.gd"

export var initial_cost = 20


func vars():
	$CollisionShape2D/AnimatedSprite.animation = "StaticServer"

func _init():
	vars()

func process_request(req):
	print('staticserver')
	return .process_request(req)
