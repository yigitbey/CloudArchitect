extends "res://Server.gd"

export var initial_cost = 200

func vars():
	$CollisionShape2D/AnimatedSprite.animation = "Database"

func _init():
	vars()
