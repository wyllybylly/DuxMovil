extends TextureButton


signal b_pressed

var style_box
var selection_box_size
var clicked


func _draw():
	draw_style_box(style_box, Rect2(Vector2.ZERO, selection_box_size))


func _ready():
	setup_border()


func _on_TTSButton_focus_entered():
	show_border()
	if pressed:
		TTSManager.say("Apagar Narrador")


func _on_TTSButton_focus_exited():
	hide_border()
	clicked = false


func _on_TTSButton_mouse_entered():
	grab_focus()


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
	hide_border()


func hide_border():
	selection_box_size = Vector2.ZERO


func show_border():
	selection_box_size = Vector2(rect_size.x, rect_size.y)


func _on_TTSButton_pressed():
	if pressed:
		if clicked:
			print("Apagar")
			TTSManager.toggle(false)
		else:
			TTSManager.say("Apagar narrador")
			clicked = true
			pressed = false
	else:
		print("Encender")
		TTSManager.toggle(true)
		TTSManager.say("Narrador encendido")

