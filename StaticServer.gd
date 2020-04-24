extends "res://Server.gd"

func vars():
	dns_prefix = "static_"

func init(level, servers, all):
	vars()
	.init(level, servers, all)
