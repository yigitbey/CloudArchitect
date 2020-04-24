extends CanvasLayer

signal user_request
signal new_staticserver
signal dns_change
signal new_lb

export var dns_record = "static_0"

func _ready():
	pass
	
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
