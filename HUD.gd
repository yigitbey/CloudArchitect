extends CanvasLayer

signal user_request
signal new_StaticServer
signal new_LoadBalancer
signal new_Database
signal new_DynamicServer
signal dns_change
signal clear
signal new_wave

signal new_server(ServerType)

export var dns_record = "<server_ip>"
var objects

func _ready():
	objects = load("res://src/objects.gd")
	objects = JSON.parse(objects.json).result

func _process(delta):
	var level = get_parent()
	$Panel/Money.text = str(level.money)
	$Panel/Wave.text = str(level.wave)

func _on_Request_pressed():
	emit_signal('user_request')

func _on_panel_button_pressed(ServerType):
	emit_signal("new_"+ServerType)
	emit_signal("new_server", ServerType)
	
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


func _on_Wave_pressed():
	emit_signal("new_wave")
