extends Node2D

signal processed


var speed = 400
var path = []
var destination = Node
var origin = Node2D
var at_target = false
var level = Node2D
var route = []
var data: String
var response: String
var money = 0
var is_malicious: bool

var ttl = 10
var alive = 0


func init2():
	level = get_parent()
	
func _ready():
	set_animation("NE")
	set_process(false)
	add_to_group("will_pause")

func set_origin(orig):
	origin = orig
	position = origin.position

func set_animation(anim):
	$AnimatedSprite.animation = anim

func _process(delta):
	alive += delta
	var move_distance = speed * delta
	move_along_path(move_distance)
	
	if path.size() == 0 and not at_target:
		arrived()
	if alive > ttl:
		pass
		
		#queue_free()
		
	if is_malicious:
		$AnimatedSprite.modulate = Color(0,0,0,0.7)
	else:
		if alive > ttl*0.5:
			$AnimatedSprite.modulate = Color(1,0.5,0)
		if alive > ttl*0.8:
			$AnimatedSprite.modulate = Color(1,0,0)


func arrived():
	at_target = true
	#set_process(false)
	destination.get_response(self)
	emit_signal('processed')
	
	
func send(speed=100):
	destination = level.iptable[self.route[-1]]
		
	pathfind(level.nav_map)
	
	at_target = false
	set_process(true)
	
func pathfind(map):
	var to = destination.global_position
	to[0] += (randi() % 50) - 25
	to[1] += (randi() % 50) - 25
	
	path = map.get_simple_path(global_position, to, false)

func move_along_path(distance):
	var start = position
	
	for _i in range(path.size()):
		choose_animation(path[0])
		var distance_to_next = start.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		distance -= distance_to_next
		start = path[0]
		path.remove(0)
	
func choose_animation(target):
	var direction = target - global_position
	if direction.x > 0 and direction.y > 0:
		$AnimatedSprite.animation = "SE"
	if direction.x > 0 and direction.y < 0:
		$AnimatedSprite.animation = "NE"
	if direction.x < 0 and direction.y > 0:
		$AnimatedSprite.animation = "SW"
	if direction.x < 0 and direction.y < 0:
		$AnimatedSprite.animation = "NW"	

func _on_Request_body_entered(body):
	modulate.a = 0.2


func _on_Request_body_exited(body):
	modulate.a = 1

func pause():
	set_process(false)
	
func resume():
	set_process(true)
