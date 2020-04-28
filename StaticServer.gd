extends "res://Server.gd"

func vars():
	$CollisionShape2D/AnimatedSprite.animation = "StaticServer"

func init(level, all):
	vars()
	.init(level, all)
