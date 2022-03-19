tool
extends Panel


const TEXT_ELECTRIC = "Algunos postes de luz pueden liberar electricidad y ser peligrosos. Lo mejor es evitar anclarnos en ellos."
const TEXT_NO_UNDOCKING = "No puedes desanclar la lancha mientras una persona está subiendo o bajando"
const TEXT_MORE_PEOPLE = "Aún quedan personas en el mapa que deben ser salvadas"
export (String) var text = TEXT_ELECTRIC setget set_text


func _ready():
	setup_text()


func set_text(new_value):
	text = new_value
	setup_text()


func setup_text():
	$Text.bbcode_text = "[center] %s [/center]" % text


func open(mode):
	get_tree().paused = true
	if mode == "Electric":
		set_text(TEXT_ELECTRIC)
	elif mode == "Undocking":
		set_text(TEXT_NO_UNDOCKING)
	elif mode == "More people":
		set_text(TEXT_MORE_PEOPLE)
	else:
		set_text(TEXT_ELECTRIC)
	show()
	TTSManager.say(text)


func _on_ConfigButton_b_pressed():
	get_tree().paused = false
	hide()
