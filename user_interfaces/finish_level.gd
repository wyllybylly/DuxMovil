extends CanvasLayer


signal back_button_pressed
signal next_button_pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	update_sizes()


func set_texts(title, description):
	$Panel/Title.text = title
	$Panel/Description.bbcode_text = "[center] %s [/center]" % description


func update_sizes():
	var half_panel_x = $Panel.rect_size.x / 2.0
	$Panel/BackToMenu.rect_min_size.x = ConfigVariables.get_text_size_m_value() * $Panel/BackToMenu.text.length()
	$Panel/BackToMenu.rect_min_size.y = ConfigVariables.get_text_size_m_value() + 10.0
	$Panel/BackToMenu.rect_size = $Panel/BackToMenu.rect_min_size
	$Panel/NextLevel.rect_min_size.x = ConfigVariables.get_text_size_m_value() * $Panel/NextLevel.text.length()
	$Panel/NextLevel.rect_min_size.y = ConfigVariables.get_text_size_m_value() + 10.0
	$Panel/NextLevel.rect_size = $Panel/NextLevel.rect_min_size
	$Panel/BackToMenu.rect_position.x = (half_panel_x- $Panel/BackToMenu.rect_size.x) / 2.0
	$Panel/NextLevel.rect_position.x = (half_panel_x - $Panel/NextLevel.rect_size.x) / 2.0 + half_panel_x
	$Panel/BackToMenu.rect_position.y = $Panel.rect_size.y - 50.0
	$Panel/NextLevel.rect_position.y = $Panel.rect_size.y - 50.0


func say_msg():
	TTSManager.say($Panel/Title.text + ". " + $Panel/Description.text)


func _on_NextLevel_b_pressed():
	emit_signal("next_button_pressed")


func _on_BackToMenu_b_pressed():
	emit_signal("back_button_pressed")
