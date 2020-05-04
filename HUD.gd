extends CanvasLayer

signal user_request
signal new_staticserver
signal dns_change
signal new_lb
signal clear

export var dns_record = "static_0"
var objects = {}

func _ready():
	print('s')
	var file = File.new()
	file.open("res://src/objects.json", file.READ)
	var text = file.get_as_text()
	objects = JSON.parse(text).result
	file.close()

func _process(delta):
	var level = get_parent()
	$Panel/Money.text = str(level.money)

func _on_Button_pressed():
	emit_signal('user_request')

func _on_new_website_pressed():
	emit_signal('new_staticserver')
	
func _on_new_lb_pressed():
	emit_signal('new_lb')

func _on_DNS_text_changed():
	dns_record = $Panel/DNS.text
	emit_signal('dns_change')


func _on_ClearUsers_pressed():
	emit_signal('clear')


func _on_panel_button_mouse_entered(ServerType):
	var Server = objects["servers"][ServerType]
	
	$ToolTip/InfoBox/Label.text = Server["name"]
	$ToolTip/InfoBox/Description.text = Server["description"]
	$ToolTip/InfoBox/GridContainer/Cost.text = str(Server["initial_cost"])
	$ToolTip/InfoBox/GridContainer/Revenue.text = str(Server["revenue"])
	$ToolTip.visible = true

func _on_panel_button_mouse_exited():
	$ToolTip.visible = false
