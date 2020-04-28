const Interface = preload("Interface.gd")
var origin : Interface
var data : String
var destination : Interface
var port: int

const allocated_ports = 1024
const max_port = 65535

func init(orig:Interface, data:String, dest:Interface) -> int:
	origin = orig
	data = data
	destination = dest
	port = randi() % (max_port-allocated_ports) + allocated_ports

	return port
