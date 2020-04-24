extends "res://Server.gd"

func vars():
	dns_prefix = "static_"
	$CollisionShape2D/AnimatedSprite.animation = "StaticServer"

func init(level, servers, all):
	vars()
	.init(level, servers, all)
