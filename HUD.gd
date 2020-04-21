extends CanvasLayer
signal path_find
signal new_website
signal dns_change

export var dns_record = "server_0"

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	emit_signal('path_find')

func _on_new_website_pressed():
	emit_signal('new_website')

func _on_DNS_text_changed():
	dns_record = $DNS.text
	emit_signal('dns_change')
