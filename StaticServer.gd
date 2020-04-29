extends "res://Server.gd"

func vars():
	$CollisionShape2D/AnimatedSprite.animation = "StaticServer"

func _init():
	vars()
