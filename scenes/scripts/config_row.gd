tool
extends HBoxContainer

export (String, "OverlaySize", "OverlayAlpha", "TextSize", "None") var config_type;
export (String) var text = "Config text" setget set_text
export (float) var min_value = 1 setget set_min_value
export (float) var max_value = 5 setget set_max_value
export (float) var step = 1 setget set_step
export (float) var value = 1 setget set_value
export (bool) var rounded = true setget set_rounded

var style_box
var config_box_pos
var config_box_size
var focused = false
var selected = false


func _ready():
	setup_border()
	set_default_values()
	set_label_size()


func _draw():
	draw_style_box(style_box, Rect2(config_box_pos, config_box_size))


func _process(delta):
	if focused:
		if Input.is_action_just_pressed("ui_accept"):
			if !selected:
				selection_border()
				TTSManager.say("Opción " + text + " seleccionada. Valor actual: " + str($ConfigOption.value))
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


func set_text(new_value):
	text = new_value
	$ConfigLabel.text = text


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


func setup_border():
	# Initialize selection boxes
	style_box = StyleBoxFlat.new()
	style_box.set_corner_radius_all(7)
	style_box.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	style_box.border_color = Color.orange
	style_box.border_width_bottom = 5
	style_box.border_width_top = 5
	style_box.border_width_left = 5
	style_box.border_width_right = 5
	config_box_pos = Vector2.ZERO
	hide_border()


func hide_border():
	config_box_size = Vector2.ZERO
	update()


func show_border():
	config_box_pos = Vector2(-10.0, -7.5)
	config_box_size = Vector2($ConfigLabel.rect_size.x + $ConfigOption.rect_size.x + 30.0, rect_size.y + 15.0)
	update()


func selection_border():
	config_box_pos = Vector2($ConfigOption.rect_position.x - 5.0, $ConfigOption.rect_position.y - 5.0)
	config_box_size = Vector2($ConfigOption.rect_size.x + 10.0, $ConfigOption.rect_size.y + 10.0)
	update()


func set_default_values():
	$ConfigOption.editable = true
	if config_type == "OverlaySize":
		$ConfigOption.value = ConfigVariables.get_overlay_size_value()
	elif config_type == "OverlayAlpha":
		$ConfigOption.value = ConfigVariables.get_overlay_alpha()
	elif config_type == "TextSize":
		$ConfigOption.value = ConfigVariables.get_text_size()
	elif config_type == "None":
		$ConfigOption.editable = false


func set_new_values():
	if config_type == "OverlaySize":
		ConfigVariables.update_overlay_size($ConfigOption.value)
	elif config_type == "OverlayAlpha":
		ConfigVariables.set_overlay_alpha($ConfigOption.value)
	elif config_type == "TextSize":
		ConfigVariables.set_text_size($ConfigOption.value)


func set_label_size():
	$ConfigLabel.rect_min_size.x = 320 + 60.0 * ConfigVariables.get_text_size()
	$ConfigLabel.rect_size.x = 320 + 60.0 * ConfigVariables.get_text_size()
	$ConfigOption.get_stylebox("custom_style/slider").set_expand_margin_individual(0.0, 0.0, 0.0, $ConfigLabel.rect_size.y - 32.0)
#	$ConfigOption.get_stylebox("custom_style/slider").region_rect.size.y = 50.0
	print(str($ConfigLabel.rect_size.y - 32.0))
	print(str($ConfigOption.get_stylebox("slider").get_expand_margin_size(3)))
	print(str($ConfigOption.get_stylebox("custom_style/slider").region_rect))


func _on_ConfigRow_focus_entered():
	show_border()
	focused = true
	selected = false
	TTSManager.say(text)


func _on_ConfigRow_focus_exited():
	hide_border()
	focused = false


func _on_ConfigRow_mouse_entered():
	grab_focus()


func _on_ConfigOption_value_changed(value):
	if focused:
		TTSManager.say("Nuevo valor de " + text + ": " + str($ConfigOption.value))
