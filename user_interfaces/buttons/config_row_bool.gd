tool
extends ConfigRowBase


export (bool) var value = true setget set_value


func _ready():
	set_label_size()


func _process(_delta):
	if focused:
		if Input.is_action_just_pressed("ui_accept"):
			if !selected:
				selection_border()
				say_option()
				SoundManager.play_se("select")
			else:
				show_border()
				SoundManager.play_se("drop")
			selected = !selected
		if selected:
			if Input.is_action_just_pressed("ui_left"):
				if $ConfigOption.pressed:
					$ConfigOption.pressed = false
					SoundManager.play_se("toggle")
			if Input.is_action_just_pressed("ui_right"):
				if !$ConfigOption.pressed:
					$ConfigOption.pressed = true
					SoundManager.play_se("toggle")


func set_value(new_value):
	value = new_value
	$ConfigOption.pressed = new_value


func set_label_size():
	$ConfigLabel.rect_min_size.x = 320 + 60.0 * ConfigVariables.get_text_size()
	$ConfigLabel.rect_size.x = 320 + 60.0 * ConfigVariables.get_text_size()
	$ConfigOption.rect_min_size.x = 64.0 + 32.0 * ConfigVariables.get_text_size()
	$ConfigOption.rect_size.x = 64.0 + 32.0 * ConfigVariables.get_text_size()
	$ConfigOption.rect_min_size.y = 16.0 + 8.0 * ConfigVariables.get_text_size()
	$ConfigOption.rect_size.y = 16.0 + 8.0 * ConfigVariables.get_text_size()

func say_option():
	TTSManager.say("Opción " + text + " seleccionada. Actual: " + ("activado" if ConfigVariables.get_default_controls() else "desactivado"))


func _on_ConfigOption_pressed():
	if focused:
		TTSManager.say("Nuevo valor de " + text + ": " + ("activado" if $ConfigOption.pressed else "desactivado"))
