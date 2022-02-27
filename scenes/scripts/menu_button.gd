tool
class_name MenuButtonBase
extends TextureButton


signal b_pressed

export (String) var text = "Text button" setget set_text

var style_box
var selection_box_size
var clicked


func _draw():
	draw_style_box(style_box, Rect2(Vector2.ZERO, selection_box_size))


func _ready():
	setup_text()
#	show_arrows()
	set_focus_mode(true)
	setup_border()


func set_text(new_value):
	text = new_value
	setup_text()


func setup_text():
	$ButtonText.bbcode_text = "[center] %s [/center]" % text


func setup_border():
	# Initialize selection boxes
	style_box = StyleBoxFlat.new()
	style_box.set_corner_radius_all(5)
	style_box.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	style_box.border_color = Color.orange
	style_box.border_width_bottom = 5
	style_box.border_width_top = 5
	style_box.border_width_left = 5
	style_box.border_width_right = 5
	hide_border()


func hide_border():
	selection_box_size = Vector2.ZERO


func show_border():
	selection_box_size = Vector2(rect_size.x, rect_size.y)


func _on_MenuButton_focus_entered():
	show_border()
	TTSManager.say(text)


func _on_MenuButton_focus_exited():
	hide_border()
	clicked = false


func _on_MenuButton_mouse_entered():
	grab_focus()


func _on_MenuButton_pressed():
	if TTSManager.is_on():
		if clicked:
			emit_signal("b_pressed")
		else:
			clicked = true
	else:
		emit_signal("b_pressed")
