tool
extends Panel


export (String) var text = "Algunos postes de luz pueden liberar electricidad y ser peligrosos. Lo mejor es evitar anclarnos en ellos." setget set_text


func _ready():
	setup_text()


func set_text(new_value):
	text = new_value
	setup_text()


func setup_text():
	$Text.bbcode_text = "[center] %s [/center]" % text


func open():
	get_tree().paused = true
	show()
	TTSManager.say(text)


func _on_ConfigButton_b_pressed():
	get_tree().paused = false
	hide()
