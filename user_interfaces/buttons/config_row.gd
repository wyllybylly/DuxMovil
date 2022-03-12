tool
extends ConfigRowBase


export (float) var min_value = 1 setget set_min_value
export (float) var max_value = 5 setget set_max_value
export (float) var step = 1 setget set_step
export (float) var value = 1 setget set_value
export (bool) var rounded = true setget set_rounded


func _ready():
	set_label_size()


func _process(_delta):
	if focused:
		if Input.is_action_just_pressed("ui_accept"):
			if !selected:
				selection_border()
				say_option()
			else:
				show_border()
			selected = !selected
		if selected:
			if Input.is_action_just_pressed("ui_down"):
				$ConfigOption.value -= $ConfigOption.step
			if Input.is_action_just_pressed("ui_up"):
				$ConfigOption.value += $ConfigOption.step
			if Input.is_action_just_pressed("ui_left"):
				$ConfigOption.value -= $ConfigOption.step
			if Input.is_action_just_pressed("ui_right"):
				$ConfigOption.value += $ConfigOption.step


func set_min_value(new_value):
	min_value = new_value
	$ConfigOption.min_value = new_value


func set_max_value(new_value):
	max_value = new_value
	$ConfigOption.max_value = new_value


func set_step(new_value):
	step = new_value
	$ConfigOption.step = new_value


func set_value(new_value):
	value = new_value
	$ConfigOption.value = new_value


func set_rounded(new_value):
	rounded = new_value
	$ConfigOption.rounded = new_value


func set_label_size():
	$ConfigLabel.rect_min_size.x = 320 + 60.0 * ConfigVariables.get_text_size()
	$ConfigLabel.rect_size.x = 320 + 60.0 * ConfigVariables.get_text_size()
	$ConfigOption.get_stylebox("custom_style/slider").set_expand_margin_individual(0.0, 0.0, 0.0, $ConfigLabel.rect_size.y - 32.0)


func say_option():
	TTSManager.say("Opción " + text + " seleccionada. Valor actual: " + str($ConfigOption.value))


func _on_ConfigOption_value_changed(_value):
	if focused:
		TTSManager.say("Nuevo valor de " + text + ": " + str($ConfigOption.value))
