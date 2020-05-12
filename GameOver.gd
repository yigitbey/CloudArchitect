extends AcceptDialog


func blocking_popup_centered():
	yield(get_tree(), "idle_frame")
	popup_centered()
	var level = get_parent().level
	$VBoxContainer/Score.text = str(floor(level.month*level.server_costs))
	var button = get_ok()
	button.pause_mode = Node.PAUSE_MODE_PROCESS
	
	get_tree().paused = true
	

