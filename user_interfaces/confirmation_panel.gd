tool
extends Panel


export (String) var text = "¿Desea volver al menú principal?" setget set_text


func _ready():
	setup_text()
	hide()


func set_text(new_value):
	text = new_value
	setup_text()


func setup_text():
	$Text.bbcode_text = "[center] %s [/center]" % text


func open():
	get_tree().paused = true
	show()
	$Accept.rect_min_size.x = ConfigVariables.get_text_size_m_value() * $Accept.text.length()
	$Accept.rect_min_size.y = ConfigVariables.get_text_size_m_value() + 10.0
	$Accept.rect_size = $Accept.rect_min_size
	$Cancel.rect_min_size.x = ConfigVariables.get_text_size_m_value() * $Cancel.text.length()
	$Cancel.rect_min_size.y = ConfigVariables.get_text_size_m_value() + 10.0
	$Cancel.rect_size = $Cancel.rect_min_size
	$Accept.rect_position.x = (250.0 - $Accept.rect_size.x) / 2.0
	$Cancel.rect_position.x = (250.0 - $Cancel.rect_size.x) / 2.0 + 250.0
	$Accept.rect_position.y = 160.0
	$Cancel.rect_position.y = 160.0
	TTSManager.say(text)
	$Text.grab_focus()


func _on_Accept_b_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://user_interfaces/menus/main_menu.tscn")


func _on_Cancel_b_pressed():
	get_tree().paused = false
	hide()
	$"/root/Boat".default_focus()
