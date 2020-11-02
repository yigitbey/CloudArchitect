extends Node2D

var level: Node2D
var step_index:int = 0
var total_steps: int
var highlight: Material
var not_highlight: Material
var run_animation = true
var tutorial: Array
var animation_timer: SceneTreeTimer

func _ready():
	level = get_parent()
	
	highlight = CanvasItemMaterial.new()
	highlight.blend_mode = BLEND_MODE_ADD
	not_highlight = CanvasItemMaterial.new()
	not_highlight.blend_mode = BLEND_MODE_MIX

func tutorial_complete(action):
	if step_index >= len(tutorial):
		return
	
	var finish_action = tutorial[step_index][2]
	if action == finish_action:
		stop_animation()
		step_index += 1
		if step_index < len(tutorial):
			var timer = get_tree().create_timer(0.5) # Wait a little while before showing the next step
			timer.connect('timeout', self, 'next')
		else:
			finish()
			
func finish():
	stop_animation()
	$Instructions.text = "Congratulations! You've finished the tutorial."
	var timer = get_tree().create_timer(5)
	timer.connect('timeout', self, 'hide_tutorial')

func start():
	tutorial = level.objects['tutorial']
	next()

func next():
	var step = tutorial[step_index]

	$Instructions.text = step[0]
	var node: Node
	if step[1] == "last_object":
		node = level.last_created_object
	else:
		node = get_tree().get_root().get_node(step[1])
	animate(node)
	
func animate(node):
	run_animation = true
	_anim1(node)
	
func stop_animation():
	run_animation = false
	#animation_timer.disconnect("timeout", self, '_anim2')

func _anim1(node):
	if run_animation:
		node.material = highlight
		animation_timer = get_tree().create_timer(0.2)
		animation_timer.connect('timeout', self, '_anim2', [node])
		
func _anim2(node):
	node.material = not_highlight

	animation_timer = get_tree().create_timer(0.2)
	animation_timer.connect('timeout', self, '_anim1', [node])


func hide_tutorial():
	visible = false
	
	
	
	
