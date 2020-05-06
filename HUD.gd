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
var level
var money_old = 0

func _ready():
	level = get_parent()
	money_old = level.money
	objects = load("res://src/objects.gd")
	objects = JSON.parse(objects.json).result

func _process(delta):
	if level.money == 0:
		$Panel/Money.modulate = Color(1,0,0,1)
	else:
		$Panel/Money.modulate = Color(1,1,1,1)
	if money_old > level.money:
			$Panel/Money.modulate = Color(1,0,0,1)
			yield(get_tree().create_timer(0.2),"timeout")
	if money_old < level.money:
			$Panel/Money.modulate = Color(0,1,0,1)
			yield(get_tree().create_timer(0.3),"timeout")
			
	$Panel/Money.text = str(level.money)
	$Panel/Wave.text = str(level.wave)
	money_old = level.money

func _on_Request_pressed():
	emit_signal('user_request')

func _on_panel_button_pressed(ServerType):
	emit_signal("new_"+ServerType)
	emit_signal("new_server", ServerType)
	
func _on_DNS_text_changed(text):
	dns_record = text
	emit_signal('dns_change')

func _on_ClearUsers_pressed():
	emit_signal('clear')


func _on_panel_button_mouse_entered(ServerType):
	var Server = objects["entities"][ServerType]
	
	$ToolTip/InfoBox/Label.text = Server["name"]
	$ToolTip/InfoBox/Description.text = Server["description"]
	$ToolTip/InfoBox/GridContainer/Cost.text = str(Server["initial_cost"])
	$ToolTip/InfoBox/GridContainer/Revenue.text = str(Server["revenue"])
	$ToolTip.visible = true

func _on_panel_button_mouse_exited():
	$ToolTip.visible = false


func _on_Wave_pressed():
	emit_signal("new_wave")

func _on_Money1000_pressed():
	level.money += 1000
