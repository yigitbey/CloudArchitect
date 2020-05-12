extends Node2D

signal user_request
signal new_StaticServer
signal new_LoadBalancer
signal new_Database
signal new_DynamicServer
signal dns_change
signal clear
signal new_wave

signal new_server(ServerType)

export var dns_record = ""
var objects
var level
var money_old = 0

func _ready():
	level = get_parent()
	money_old = level.money
	objects = load("res://src/objects.gd")
	objects = JSON.parse(objects.json).result
	
	$WeekControl/WaveProgress.max_value = objects['week']['duration']
	$Messages/List.add_item("")
	

func _process(delta):
	if level.money <= 0:
		$Panel/Money.modulate = Color(1,0,0,1)
		$GameOver.blocking_popup_centered()
	else:
		$Panel/Money.modulate = Color(1,1,1,1)
	
	if money_old > level.money:
			$Panel/Money.modulate = Color(1,0,0,1)
			yield(get_tree().create_timer(0.2),"timeout")
	if money_old < level.money:
			$Panel/Money.modulate = Color(0,1,0,1)
			yield(get_tree().create_timer(0.3),"timeout")
			
	$Panel/Money.text = str(level.money)
	$Panel/Cost.text = str(level.product_cost)
	$Panel/WaveIncome.text = str(level.wave_income)
	money_old = level.money
	$WeekControl/WaveProgress.value = level.week_timer.wait_time - level.week_timer.time_left
	$WeekControl/WaveProgress/Wave.text = str(level.wave)

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
	$ToolTip/InfoBox/GridContainer/Cost.text = str(Server["initial_cost"])
	$ToolTip/InfoBox/GridContainer/Revenue.text = str(Server["revenue"])
	$ToolTip.visible = true

func _on_panel_button_mouse_exited():
	$ToolTip.visible = false


func _on_Wave_pressed():
	start_week()

func start_week():
	if !dns_record:
		add_message("DNS is not configured")
		warning_animation($Panel/DNS)
		return false
	else:
		level.week_timer.start()
		add_message("Starting week.")
		emit_signal("new_wave")
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
	if level.week_timer.time_left == 0:
		if start_week():
			$WeekControl/AutoAdvance/FontAwesome.icon_name = "history"
			add_message("Auto advance on")
			$WeekControl/AutoAdvance.pressed = true
		else:
			$WeekControl/AutoAdvance.pressed = false
	else:
		if $WeekControl/AutoAdvance.pressed:
			level.week_timer.one_shot = false
			level.week_timer.paused = false
			$WeekControl/AutoAdvance.pressed = true
			add_message("Auto advance on")
		else:
			level.week_timer.one_shot = true
			$WeekControl/AutoAdvance.pressed = false
			add_message("Auto advance off")
