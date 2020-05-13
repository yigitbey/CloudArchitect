extends Node2D

signal user_request
signal new_StaticServer
signal new_LoadBalancer
signal new_Database
signal new_DynamicServer
signal dns_change
signal clear
signal new_month

signal new_server(ServerType)

export var dns_record = ""
var objects
var level
var money_old = 0

var entity_buttons = [
	"new_LoadBalancer", "new_Database", "new_Firewall",
	"new_DynamicServer", "new_StaticServer"
	]

func _ready():
	level = get_parent()
	money_old = level.money
	objects = load("res://src/objects.gd")
	objects = JSON.parse(objects.json).result
	
	$MonthControl/MonthProgress.max_value = objects['month']['duration']
	$Messages/List.add_item("")
	

func _process(delta):
	if level.money <= 0:
		$Panel/FinancesButton.modulate = Color(1,0,0,1)
		#$GameOver.popup_centered()
	else:
		$Panel/FinancesButton.modulate = Color(1,1,1,1)
	
	if money_old > level.money:
			$Panel/FinancesButton.modulate = Color(1,0,0,1)
			yield(get_tree().create_timer(0.2),"timeout")
	if money_old < level.money:
			$Panel/FinancesButton.modulate = Color(0,1,0,1)
			yield(get_tree().create_timer(0.3),"timeout")
			
	$Panel/FinancesButton.text = str(floor(level.money))
	$FinancesPanel/TotalBalance.text = str(floor(level.money))
	$FinancesPanel/ProductCost.text = str(floor(level.product_cost))
	$FinancesPanel/ServerCosts.text = str(floor(level.server_costs))
	$FinancesPanel/MonthlyIncome.text = str(floor(level.month_income))
	$FinancesPanel/Profit.text = str(floor(level.month_income - level.product_cost - level.server_costs))
	
	money_old = level.money
	$MonthControl/MonthProgress.value = level.month_timer.wait_time - level.month_timer.time_left
	$MonthControl/MonthProgress/Month.text = str(level.month)

	for msg in level.messages:
		add_message(level.messages.pop_front())
	
func _on_Request_pressed(is_malicious=false):
	emit_signal('user_request', is_malicious)

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
	$ToolTip/InfoBox/GridContainer/Cost.text = str(Server["monthly_cost"])
	$ToolTip/InfoBox/GridContainer/Revenue.text = str(Server["revenue"])
	$ToolTip.visible = true

func _on_panel_button_mouse_exited():
	$ToolTip.visible = false


func _on_month_pressed():
	level.money -= level.server_costs + level.product_cost #TODO: move to level
	start_month()

func start_month():
	if not dns_record in level.iptable:
		add_message("DNS is not configured")
		warning_animation($Panel/DNS)
		return false
	else:
		level.month_timer.start()
		add_message("Starting month.")
		emit_signal("new_month")
		return true

func warning_animation(container):
	for _i in range(5):
		container.modulate = Color(1,0,0,1)
		yield(get_tree().create_timer(0.1), "timeout")
		container.modulate = Color(1,1,1,1)
		yield(get_tree().create_timer(0.1), "timeout")

func _on_Money1000_pressed():
	level.money += 1000

func _on_GameOver_confirmed():
	get_tree().change_scene("res://Level.tscn")


func add_message(msg):
	$Messages/List.add_item(msg)
	$Messages/List.select($Messages/List.get_item_count()-1)
	$Messages/List.ensure_current_is_visible()

func _on_AutoAdvance_pressed():
	if level.month_timer.time_left == 0:
		if start_month():
			$MonthControl/AutoAdvance/FontAwesome.icon_name = "history"
			add_message("Auto advance on")
			$MonthControl/AutoAdvance.pressed = true
			level.month_timer.one_shot = false
		else:
			$MonthControl/AutoAdvance.pressed = false
	else:
		if $MonthControl/AutoAdvance.pressed:
			level.month_timer.one_shot = false
			level.month_timer.paused = false
			$MonthControl/AutoAdvance.pressed = true
			add_message("Auto advance on")
		else:
			level.month_timer.one_shot = true
			$MonthControl/AutoAdvance.pressed = false
			add_message("Auto advance off")

func _on_FinancesButton_toggled(button_pressed):
	if button_pressed:
		$FinancesPanel.show()
	else:
		$FinancesPanel.hide()


func _on_restart_pressed():
	get_tree().change_scene("res://Level.tscn")
