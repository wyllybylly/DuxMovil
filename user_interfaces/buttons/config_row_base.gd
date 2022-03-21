tool
class_name ConfigRowBase
extends HBoxContainer


export (String, "OverlaySize", "OverlayAlpha", "TextSize", "DefaultControls", "DisabledSlider", "None") var config_type;
export (String) var text = "Config text" setget set_text

var style_box
var config_box_pos
var config_box_size
var focused = false
var selected = false


func _ready():
	setup_border()
	set_default_values()


func _draw():
	draw_style_box(style_box, Rect2(config_box_pos, config_box_size))


func set_text(new_value):
	text = new_value
	$ConfigLabel.text = text


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
	if config_type == "OverlaySize":
		$ConfigOption.value = ConfigVariables.get_overlay_size_value()
		$ConfigOption.editable = true
	elif config_type == "OverlayAlpha":
		$ConfigOption.value = ConfigVariables.get_overlay_alpha()
		$ConfigOption.editable = true
	elif config_type == "TextSize":
		$ConfigOption.value = ConfigVariables.get_text_size()
		$ConfigOption.editable = true
	elif config_type == "DefaultControls":
		$ConfigOption.pressed = ConfigVariables.get_default_controls()
	elif config_type == "DisabledSlider":
		$ConfigOption.editable = false


func set_new_values():
	if config_type == "OverlaySize":
		ConfigVariables.update_overlay_size($ConfigOption.value)
	elif config_type == "OverlayAlpha":
		ConfigVariables.set_overlay_alpha($ConfigOption.value)
	elif config_type == "TextSize":
		ConfigVariables.set_text_size($ConfigOption.value)
	elif config_type == "DefaultControls":
		ConfigVariables.set_default_controls($ConfigOption.pressed)


func _on_ConfigRow_focus_entered():
	show_border()
	focused = true
	selected = false
	TTSManager.say(text)
	SoundManager.play_se("pluck")


func _on_ConfigRow_focus_exited():
	hide_border()
	focused = false


func _on_ConfigRow_mouse_entered():
	grab_focus()


func _on_ConfigRow_mouse_exited():
	if (!TTSManager.is_on()) and ConfigVariables.get_default_controls():
		release_focus()
