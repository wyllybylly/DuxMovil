extends Node


signal menu_closed

var from_level = false


func save():
	# Save values
	for option in $VBox/Center/Options.get_children():
		option.set_new_values()
	# Update elements
	for option in $VBox/Center/Options.get_children():
		option.set_label_size()
	for button in $VBox/ButtonsSave.get_children():
		button.update_size()
	for button in $VBox/ButtonsCancel.get_children():
		button.update_size()
	yield(get_tree(), "idle_frame")
	$VBox/ButtonsSave/Save.show_border()


func close():
	if !from_level:
		get_tree().change_scene("res://user_interfaces/menus/main_menu.tscn")
	else:
		emit_signal("menu_closed")


func reset():
	for option in $VBox/Center/Options.get_children():
		option.set_default_values()


func _on_Save_b_pressed():
	save()
	$VBox/ButtonsSave/Save.grab_focus()


func _on_SaveAndClose_b_pressed():
	save()
	close()


func _on_Cancel_b_pressed():
	close()


func _on_Reset_b_pressed():
	reset()
