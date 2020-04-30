const Interface = preload("Interface.gd")
var origin : String
var data : String
var destination : String
var port: int

const allocated_ports = 1024
const max_port = 65535

func init(orig:String, data2:String, dest:String) -> int:
	origin = orig
	data = data2
	destination = dest
	port = randi() % (max_port-allocated_ports) + allocated_ports

	return port
