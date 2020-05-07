extends AcceptDialog

func blocking_popup_centered():
	yield(get_tree(), "idle_frame")
	popup_centered()
	emit_signal("confirmedc")
