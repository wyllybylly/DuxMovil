extends Node


func _ready():
	TTSManager.toggle(true)
	$VBoxContainer/VBoxContainer/Start.grab_focus()
	yield(get_tree(), "idle_frame")
	ConfigVariables.update_font_sizes()


func _on_Start_pressed():
	TTSManager.say("Start Presionado")
	get_tree().change_scene("res://levels/level1.tscn")


func _on_Config_pressed():
	get_tree().change_scene("res://user_interfaces/menus/config_menu.tscn")


func _on_AboutUs_pressed():
	TTSManager.say("About us Presionado")


func _on_Quit_pressed():
	TTSManager.say("Quit Presionado")
	get_tree().quit()


func _on_TTSButton_pressed():
	if $TTSButton.pressed:
		print("TTS OFF")
	else:
		print("TTS ON")
