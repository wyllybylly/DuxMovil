extends Node


var overlay_size = 3.0
var default_overlay_size = 0.0
var overlay_alpha = 0.8
var text_size = 3
var text_size_l_values = [ 20, 28, 34, 42, 50, 56 ]
var text_size_m_values = [ 18, 20, 22, 24, 28, 32 ]
var touch_controls = true


# Called when the node enters the scene tree for the first time.
func _ready():
	default_overlay_size = get_viewport().size.y / 540
	update_font_sizes()


func get_overlay_size():
	return overlay_size * default_overlay_size


func get_overlay_size_value():
	return overlay_size


func update_overlay_size(new_value):
	overlay_size = new_value


func get_overlay_alpha():
	return overlay_alpha


func set_overlay_alpha(new_alpha):
	overlay_alpha = new_alpha


func get_text_size():
	return text_size


func set_text_size(new_size):
	text_size = new_size
	update_font_sizes()


func get_text_size_l_value(size = -1):
	if size == -1:
		return text_size_l_values[text_size]
	else:
		return text_size_l_values[size]


func get_text_size_m_value(size = -1):
	if size == -1:
		return text_size_m_values[text_size]
	else:
		return text_size_m_values[size]


func update_font_sizes():
	var font = load("res://fonts/tres/menu_button.tres")
	font.set_size(get_text_size_m_value())
	font = load("res://fonts/tres/config_label.tres")
	font.set_size(get_text_size_m_value())
	font = load("res://fonts/tres/help_text.tres")
	font.set_size(get_text_size_m_value())
	font = load("res://fonts/tres/menu_title.tres")
	font.set_size(get_text_size_l_value())


func set_touch_controls(new_value):
	touch_controls = new_value


func get_touch_controls():
	return touch_controls
