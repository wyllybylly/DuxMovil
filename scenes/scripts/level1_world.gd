extends Node2D


var onMenu
var helpScreenLevel


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelVariables.water_speed = 0.0
	$Boat.update_water_speed()
	$Water.update_water_speed()
	var camera = $Boat/Boat/FollowBoatCamera
	var water_size = $Water.region_rect.size
	camera.limit_bottom = $Water.global_position.y + water_size.y / 2
	camera.limit_top = $Water.global_position.y - water_size.y / 2
	camera.limit_left = $Water.global_position.x - water_size.x / 2
	camera.limit_right = $Water.global_position.x + water_size.x / 2
	
	# Set first help screen
	get_tree().paused = true
	$Help/Background.node_path = "../../Boat/GUI/Frame"
	$Help/Background.poly_type = "Rectangle"
	$Help/Background.show()
	$Help/TextPower.show()
	$Help/Button.show()
	$Help/TextAnchor.hide()
	$Help/TextSave.hide()
	$Help/TextSteering.hide()
	onMenu = true
	helpScreenLevel = 1


func _process(delta):
	if onMenu:
		if Input.is_action_just_released("ui_accept"):
			next_screen()


func _on_Button_button_up():
	next_screen()


func next_screen():
	if helpScreenLevel == 1:
		if onMenu:
			$Help/Background.hide()
			$Help/TextPower.hide()
			$Help/Button.hide()
			onMenu = false
		else:
			$Help/Background.show()
			$Help/TextSteering.show()
			$Help/Button.show()
			onMenu = true
			helpScreenLevel = 2
	elif helpScreenLevel == 2:
		if onMenu:
			pass
		else:
			pass
	elif helpScreenLevel == 3:
		if onMenu:
			pass
		else:
			pass
	elif helpScreenLevel == 4:
		if onMenu:
			pass
		else:
			pass
