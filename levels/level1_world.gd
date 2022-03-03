extends Node2D


var onHelpView
var helpScreenLevel
var helpArray
var people = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelVariables.water_speed = 0.0
	$Boat.update_water_speed()
	$World/Water.update_water_speed()
	var camera = $Boat/Boat/FollowBoatCamera
	var water_size = $World/Water.region_rect.size
	camera.limit_bottom = $World/Water.global_position.y + water_size.y / 2
	camera.limit_top = $World/Water.global_position.y - water_size.y / 2
	camera.limit_left = $World/Water.global_position.x - water_size.x / 2
	camera.limit_right = $World/Water.global_position.x + water_size.x / 2
	
	# Set first help screen
	$Help/Background.show()
	$Help/Button.show()
	$Help/TextDocking.hide()
	$Help/TextSave.hide()
	$Help/TextSteering.hide()
	$Help/TextSigns.hide()
	set_text_config($Help/TextPower, 0.85)
	set_text_config($Help/TextSteering)
	set_text_config($Help/TextDocking, 1.0, 0.2)
	set_text_config($Help/TextSave, 1.0, 0.2)
	set_text_config($Help/TextSigns)
	$Help/TextSteering/PhoneIcon.position.x = $Help/TextSteering.rect_size.x / 2
	$Boat/GUI/DockButton.hide()
	$Boat/GUI/RescueButton.hide()
	onHelpView = false
	helpScreenLevel = 0
	helpArray = [
		[$Help/TextPower, "Rectangle", $Boat/GUI/Frame],
		[$Help/TextSteering, "None"],
		[$Help/TextDocking, "Circle", $Boat/GUI/DockButton],
		[$Help/TextSave, "Circle", $Boat/GUI/RescueButton],
		[$Help/TextSigns, "None"]
	]
	
	var icon_size = Vector2(ConfigVariables.get_text_size_l_value(), ConfigVariables.get_text_size_l_value()) * 1.25
	for sign_line in $Help/TextSigns/SignList.get_children():
		var child_count = sign_line.get_child_count()
		var description = sign_line.get_child(child_count - 1)
		description.rect_min_size.x = $Help/TextSigns.rect_size.x - ConfigVariables.get_text_size_l_value() * (child_count - 1)
		for i in (child_count - 1):
			sign_line.get_child(i).rect_min_size = icon_size
	
	next_screen()
	
	# Set finish panel
	$FinishLevel/Panel.hide()
	var title = "Has completado el tutorial"
	var description = "Ya tienes los conocimientos básicos para comenzar a jugar"
	$FinishLevel.set_texts(title, description)


func _process(_delta):
	if onHelpView:
		if Input.is_action_just_released("ui_accept"):
			next_screen()


func _on_NextHelp_body_entered(body):
	if body.name == "Boat":
		next_screen()
#		queue_free()


func _on_TurnOnWater_body_entered(body):
	if body.name == "Boat":
		LevelVariables.water_speed = 10.0
		$Boat.update_water_speed()
		$World/Water.update_water_speed()
		$Triggers/TurnOnWater.queue_free()


func next_screen():
	if onHelpView:
		hide_help_view(helpArray[helpScreenLevel][0])
	else:
		$Help/Background.poly_type = helpArray[helpScreenLevel][1]
		if helpArray[helpScreenLevel].size() == 3:
			var button = helpArray[helpScreenLevel][2]
			$Help/Background.node_path = button.get_path()
			button.show()
		$Help/Background.update_shape()
		show_help_view(helpArray[helpScreenLevel][0])
		if helpScreenLevel > 0:
			$Triggers.get_child(0).queue_free()
	onHelpView = !onHelpView
	get_tree().paused = !get_tree().paused


func hide_help_view(text):
	$Help/Background.hide()
	text.hide()
	$Help/Button.hide()
	helpScreenLevel += 1


func show_help_view(text):
	$Help/Background.show()
	text.show()
	$Help/Button.show()
	$Help/Button.update_size()
	TTSManager.say(text.text)


func set_text_config(text, right = 1.0, left = 0.0, bottom = 0.9, top = 0.0):
	text.anchor_bottom = 0.0
	text.anchor_left = 0.0
	text.anchor_right = 0.0
	text.anchor_top = 0.0
	var view_y = get_viewport_rect().size.y - 50
	var view_x = get_viewport_rect().size.x - 50
	text.margin_bottom = 25 + view_y * bottom
	text.margin_left = 25 + view_x * left
	text.margin_right = 25 + view_x * right
	text.margin_top = 25 + view_y * top


func _on_Boat_person_safe():
	people -= 1
	if people == 0:
		finish_menu()


func finish_menu():
	get_tree().paused = true
	$FinishLevel/Panel.show()


func _on_FinishLevel_back_button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://user_interfaces/menus/main_menu.tscn")


func _on_FinishLevel_next_button_pressed():
	pass
#	get_tree().change_scene("res://levels/level2.tscn")


func _on_Button_b_pressed():
	next_screen()
