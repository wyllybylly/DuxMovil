class_name CustomButtonBase
extends TextureButton


signal b_pressed

export (String) var text = "Text button"

var style_box
var selection_box_size
var clicked


func _draw():
	draw_style_box(style_box, Rect2(Vector2.ZERO, selection_box_size))


func _ready():
	setup_border()


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


func _on_GameButton_mouse_entered():
	grab_focus()
	SoundManager.play_se("pluck")


func _on_GameButton_focus_entered():
	show_border()
	TTSManager.say(text)


func _on_GameButton_focus_exited():
	hide_border()
	clicked = false


func _on_GameButton_pressed():
	if TTSManager.is_on():
		if clicked:
			emit_signal("b_pressed")
			SoundManager.play_se("select")
		else:
			clicked = true
			SoundManager.play_se("click")
	else:
		emit_signal("b_pressed")
		SoundManager.play_se("select")
