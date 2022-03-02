extends CanvasLayer


signal back_button_pressed
signal next_button_pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.rect_min_size = get_viewport().size / 2
	$Panel.margin_left = get_viewport().size.x / 4
	$Panel.margin_top = get_viewport().size.y / 4
	set_texts_positions()
	$Panel/BackButton.rect_position.y = $Panel.rect_size.y * 0.9 - $Panel/BackButton.rect_size.y / 2
	$Panel/BackButton.rect_position.x = $Panel.rect_size.x * 0.2 - $Panel/BackButton.rect_size.x / 2
	$Panel/NextButton.rect_position.y = $Panel.rect_size.y * 0.9 - $Panel/NextButton.rect_size.y / 2
	$Panel/NextButton.rect_position.x = $Panel.rect_size.x * 0.8 - $Panel/NextButton.rect_size.x / 2


func _on_NextButton_button_up():
	emit_signal("next_button_pressed")


func _on_BackButton_button_up():
	emit_signal("back_button_pressed")


func set_texts_positions():
	$Panel/Title.rect_position.y = $Panel.rect_size.y / 10
	$Panel/Title.rect_position.x = ($Panel.rect_size.x - $Panel/Title.rect_size.x) / 2
	$Panel/Description.rect_position = ($Panel.rect_size - $Panel/Description.rect_size) / 2


func set_texts(title, description):
	$Panel/Title.text = title
	$Panel/Description.text = description
	set_texts_positions()
