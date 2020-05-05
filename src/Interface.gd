export var ip: String
const max_ip_block = 256
var ports = {}

func _init():
	ip = "10.0."+ str(randi()%max_ip_block) + "." + str(randi()%max_ip_block)

