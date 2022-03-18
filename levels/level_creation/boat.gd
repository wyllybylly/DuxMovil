extends Node2D


export (float) var max_speed = 20

signal person_rescue
signal person_safe


enum actions_enum {
	IDLE,
	TURN_RIGHT,
	TURN_LEFT,
	POWER_UP,
	POWER_DOWN,
}


const SEATS = [
	[Vector2(0, -50), -90],
	[Vector2(15, -45), -45],
	[Vector2(-15, -45), -135],
	[Vector2(20, -30), 0],
	[Vector2(-20, -30), 180],
	[Vector2(0, -35), -90],
	[Vector2(0, -20), -90],
	[Vector2(20, -12.5), 0],
	[Vector2(-20, -12.5), 180],
	[Vector2(20, 5), 0],
	[Vector2(-20, 5), 180],
	[Vector2(20, 22.5), 0],
	[Vector2(-20, 22.5), 180],
	[Vector2(20, 40), 0],
	[Vector2(-20, 40), 180],
]
const button_tex_1 = preload("res://user_interfaces/textures/to_boat_button.png")
const button_tex_2 = preload("res://user_interfaces/textures/to_safe_zone_button.png")

var speed = 0.0
var water_speed = 10.0
var lever_height = Vector2(0,0) # [0] min pos, [1] max movement
var power_selected = false
var docked = false
var max_seats = 15
var used_seats = 0
var from_point
var to_point
var rope_color
var rope_lenght
var stabilizing
var current_action = actions_enum.IDLE
var can_rescue = false
var can_undock = true


func _draw():
	draw_line(from_point, to_point, rope_color, 2.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize overlay positions
	set_overlay()
	default_focus()
	
	# Initialize water speed
	water_speed = LevelVariables.water_speed
	
	# Initialize rope variables
	from_point = Vector2.ZERO
	to_point = Vector2.ZERO
	rope_color = Color("87633B")
	
	# Options
	$GUI/ConfigMenu.hide()
	$GUI/ConfigMenu.from_level = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not docked:
		# Movement
		if ConfigVariables.get_default_controls(): 
			if Input.get_accelerometer().x > 3.0:
				rotate(delta)
			if Input.get_accelerometer().x < -3.0:
				rotate(-delta)
		else:
			if current_action == actions_enum.TURN_RIGHT and speed != 0.0:
				rotate(delta)
			elif current_action == actions_enum.TURN_LEFT and speed != 0.0:
				rotate(-delta)
			elif current_action == actions_enum.POWER_UP:
				power_up(delta)
			elif current_action == actions_enum.POWER_DOWN:
				power_down(delta)
		var movement = Vector2()
		if speed != 0.0:
			movement += Vector2(1, 0).rotated($Boat.rotation - PI / 2) * speed * (1 - 0.02 * used_seats)
		movement.y += water_speed
		$Boat.move_and_collide(movement * delta * 10)
	else:
		if stabilizing:
			power_down(delta)
			var movement = $Boat.position.direction_to(Vector2(to_point.x, to_point.y + 75.0 + rope_lenght))
			if $Boat.rotation != 0.0:
				stabilize_rotation(delta * movement.y)
			var distance = $Boat.position.distance_to(Vector2(to_point.x, to_point.y + 75.0 + rope_lenght))
			if distance >= 1.0:
				$Boat.move_and_collide(movement * delta * 10 * water_speed)
			from_point = Vector2($Boat.position.x + sin($Boat.rotation) * 75.0, $Boat.position.y + cos($Boat.rotation) * -75.0)
			update()
			if distance < 1.0 and $Boat.rotation == 0.0:
				stabilizing = false
				can_rescue = true
				update_rescue_button()


func _physics_process(delta):
	if power_selected:
		if get_viewport().get_mouse_position().y < $GUI/Lever.global_position.y:
			power_up(delta)
		else:
			power_down(delta)


func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			power_selected = false


func power_up(delta):
	speed = min(speed + 20.0 * delta, max_speed)
	update_lever_y()
	TTSManager.say("Motor al " + str(round(speed / max_speed * 100)) + "%")


func power_down(delta):
	speed = max(speed - 20.0 * delta, 0)
	update_lever_y()
	TTSManager.say("Motor al " + str(round(speed / max_speed * 100)) + "%")


func rotate(delta):
	$Boat.rotate(PI / 4 * delta)


func stabilize_rotation(delta):
	if delta > 0.0:
		if $Boat.rotation > 0.0:
			$Boat.rotation = max($Boat.rotation - PI / 4 * delta, 0.0)
		else:
			$Boat.rotation = min($Boat.rotation + PI / 4 * delta, 0.0)


func update_lever_y():
	if ConfigVariables.get_default_controls():
		$GUI/Lever.position.y = lever_height.x - (speed / max_speed) * lever_height.y
	else:
		$GUI/EngineView.value = round(speed / max_speed * 100)


func update_water_speed():
	water_speed = LevelVariables.water_speed


func get_seat():
	if max_seats > used_seats:
		used_seats += 1
		# Get position and rotation to seat
		return SEATS[used_seats - 1]


func get_person():
	if used_seats > 0:
		used_seats -= 1
		var person = $Boat.get_child($Boat.get_child_count() - 1)
		return person


func set_overlay():
	# Initialize variables
	var scale_value = 1.4 + ConfigVariables.get_overlay_size() * 0.2
	$GUI/OptionsButton.grab_focus()
	
	# Setup dock button
	$GUI/DockButton.rect_position = Vector2(20.0, get_viewport().size.y - 15.0 * ConfigVariables.get_overlay_size() - 110.0)
	$GUI/DockButton.rect_scale = Vector2(scale_value, scale_value)
	$GUI/DockButton.modulate.a = ConfigVariables.overlay_alpha
	
	# Setup rescue button
	$GUI/RescueButton.rect_position = Vector2(20.0, get_viewport().size.y - 35.0 * ConfigVariables.get_overlay_size() - 200.0)
	$GUI/RescueButton.rect_scale = Vector2(scale_value, scale_value)
	$GUI/RescueButton.modulate.a = ConfigVariables.overlay_alpha
	
	if ConfigVariables.get_default_controls():
		# Show & hide buttons
		$GUI/Lever.show()
		$GUI/Frame.show()
		$GUI/LeftTurnButton.hide()
		$GUI/RightTurnButton.hide()
		$GUI/PowerUpButton.hide()
		$GUI/PowerDownButton.hide()
		$GUI/EngineView.hide()
		
		# Initialize variables
		var mid_height = get_viewport().size.y / 2.0
		var engine_scale = ConfigVariables.get_overlay_size() * 0.6 + 1.0
		
		# Setup Lever & Frame
		$GUI/Frame.position = Vector2(get_viewport().size.x - 30.0 * engine_scale, mid_height)
		$GUI/Lever.position = Vector2(get_viewport().size.x - 30.0 * engine_scale, mid_height + 48 * engine_scale)
		$GUI/Lever/LeverSprite.position = Vector2.ZERO
		$GUI/Lever/LeverCollision.position = Vector2.ZERO
		lever_height = Vector2($GUI/Lever.position.y, 96 * engine_scale)
		$GUI/Lever.scale = Vector2(engine_scale,engine_scale)
		$GUI/Frame.scale = Vector2(engine_scale,engine_scale)
		$GUI/Lever/LeverSprite.modulate.a = ConfigVariables.overlay_alpha
		$GUI/Frame.modulate.a = ConfigVariables.overlay_alpha
		
		# Setup options button
		if ($GUI/Frame.scale.y * $GUI/Frame.get_rect().size.y + scale_value * 2.0 * $GUI/OptionsButton.rect_size.y + 50.0) > get_viewport().size.y:
#			$GUI/OptionsButton.rect_position = Vector2(get_viewport().size.x - (40.0 * ConfigVariables.get_overlay_size() + 200.0 if ConfigVariables.get_overlay_size() >= 3 else 20.0 * ConfigVariables.get_overlay_size() + 100.0), 10.0)
			$GUI/OptionsButton.rect_position = Vector2($GUI/Frame.position.x - ConfigVariables.get_overlay_size() * 15.0 - 200.0, 10.0)
		else:
			$GUI/OptionsButton.rect_position = Vector2(get_viewport().size.x - $GUI/OptionsButton.rect_size.x * scale_value - 10.0, 10.0)
		$GUI/OptionsButton.rect_scale = Vector2(scale_value, scale_value)
		$GUI/OptionsButton.modulate.a = ConfigVariables.overlay_alpha
	else:
		# Show & hide buttons
		$GUI/Lever.hide()
		$GUI/Frame.hide()
		$GUI/LeftTurnButton.show()
		$GUI/RightTurnButton.show()
		$GUI/PowerUpButton.show()
		$GUI/PowerDownButton.show()
		$GUI/EngineView.show()
		
		# Setup right turn button
		$GUI/RightTurnButton.rect_position.x = get_viewport().size.x - (20.0 * ConfigVariables.get_overlay_size() + 100.0)
		$GUI/RightTurnButton.rect_position.y = $GUI/DockButton.rect_position.y
		$GUI/RightTurnButton.rect_scale = Vector2(scale_value, scale_value)
		$GUI/RightTurnButton.modulate.a = ConfigVariables.overlay_alpha
		
		# Setup power down button
		$GUI/PowerDownButton.rect_position = $GUI/RightTurnButton.rect_position
		$GUI/PowerDownButton.rect_position.x -= ConfigVariables.get_overlay_size() * 15.0 + 100.0
		$GUI/PowerDownButton.rect_scale = Vector2(scale_value, scale_value)
		$GUI/PowerDownButton.modulate.a = ConfigVariables.overlay_alpha
		
		# Setup power up button
		$GUI/PowerUpButton.rect_position = $GUI/PowerDownButton.rect_position
		$GUI/PowerUpButton.rect_position.y -= ConfigVariables.get_overlay_size() * 15.0 + 100.0
		$GUI/PowerUpButton.rect_scale = Vector2(scale_value, scale_value)
		$GUI/PowerUpButton.modulate.a = ConfigVariables.overlay_alpha
		
		# Setup left turn button
		$GUI/LeftTurnButton.rect_position = $GUI/PowerDownButton.rect_position
		$GUI/LeftTurnButton.rect_position.x -= ConfigVariables.get_overlay_size() * 15.0 + 100.0
		$GUI/LeftTurnButton.rect_scale = Vector2(scale_value, scale_value)
		$GUI/LeftTurnButton.modulate.a = ConfigVariables.overlay_alpha
		
		# Setup options button
		$GUI/OptionsButton.rect_position = Vector2($GUI/RightTurnButton.rect_position.x, 10.0)
		$GUI/OptionsButton.rect_scale = Vector2(scale_value, scale_value)
		$GUI/OptionsButton.modulate.a = ConfigVariables.overlay_alpha
		
		# Setup engine view
		$GUI/EngineView.rect_position.x = $GUI/RightTurnButton.rect_position.x
		$GUI/EngineView.rect_position.y = $GUI/PowerUpButton.rect_position.y
		$GUI/EngineView.rect_scale = Vector2(scale_value, scale_value)
		$GUI/EngineView.modulate.a = ConfigVariables.overlay_alpha
	update_lever_y()
	
	# Setup home button
	$GUI/HomeButton.rect_position = $GUI/OptionsButton.rect_position
	$GUI/HomeButton.rect_position.x -= ConfigVariables.get_overlay_size() * 15.0 + 100.0
	$GUI/HomeButton.rect_scale = Vector2(scale_value, scale_value)
	$GUI/HomeButton.modulate.a = ConfigVariables.overlay_alpha


func default_focus():
	if !ConfigVariables.get_default_controls():
		$GUI/HomeButton.grab_focus()


func update_rescue_button():
	if can_rescue:
		if not $Boat/RescueArea.get_overlapping_bodies().empty():
			$GUI/RescueButton.disabled = false
			$GUI/RescueButton.texture_normal = button_tex_1
			print("Subir persona")
		elif not $Boat/SafeZoneArea.get_overlapping_areas().empty():
			$GUI/RescueButton.disabled = false
			$GUI/RescueButton.texture_normal = button_tex_2
			print("Dejar persona")
		else:
			$GUI/RescueButton.disabled = true
			print("No hay áreas disponibles")
	else:
		$GUI/RescueButton.disabled = true
		print("No puede rescatar")


func rescue_finished():
	can_rescue = true
	can_undock = true
	emit_signal("person_rescue")
	update_rescue_button()


func person_safe():
	can_rescue = true
	can_undock = true
	emit_signal("person_safe")
	update_rescue_button()


func _on_DockButton_b_pressed():
	# If boat is docked, undock it
	if docked:
		if can_undock:
			docked = false
			from_point = to_point
			update()
			TTSManager.say("Lancha suelta")
			$GUI/RescueButton.disabled = true
		else:
			$NoPause/HelpPanel.open("Undocking")
			# Mostrar cartel
	# Else, check if there is dockable areas
	else:
		# If there is, dock
		if not $Boat/DockArea.get_overlapping_bodies().empty():
			var dock_body = $Boat/DockArea.get_overlapping_bodies().pop_front()
			if dock_body.type == "Electric":
				$NoPause/HelpPanel.open("Electric")
			else:
				docked = true
				from_point = Vector2($Boat.position.x + sin($Boat.rotation) * 75.0, $Boat.position.y + cos($Boat.rotation) * -75.0)
				to_point = dock_body.global_position - global_position
				rope_lenght = from_point.distance_to(to_point)
				update()
				stabilizing = true
				update_rescue_button()
				TTSManager.say("Lancha anclada")
		# Else notify
		else:
			TTSManager.say("No se encontró lugar para anclar")


func _on_RescueButton_b_pressed():
	if docked:
		# If there is a person to rescue, rescue them
		if not $Boat/RescueArea.get_overlapping_bodies().empty():
			var person = $Boat/RescueArea.get_overlapping_bodies().pop_front()
			var seat = get_seat()
			if seat != null:
				person.start_rescue($Boat, seat, self)
				can_rescue = false
				can_undock = false
				TTSManager.say("Se subió una persona a la lancha")
			else:
				TTSManager.say("No hay más lugar en la lancha")
			yield(get_tree(), "physics_frame")
			update_rescue_button()
		# If there is a safe zone, leave a person on  it
		elif not $Boat/SafeZoneArea.get_overlapping_areas().empty():
			var safe_zone = $Boat/SafeZoneArea.get_overlapping_areas().pop_front()
			var person = get_person()
			if person != null:
				person.get_to_safe_zone(safe_zone)
				can_rescue = false
				can_undock = false
				TTSManager.say("Se dejó una persona en zona segura")
			yield(get_tree(), "physics_frame")
			update_rescue_button()
		# Else do nothing


func _on_OptionsButton_b_pressed():
	get_tree().paused = true
	$GUI/ConfigMenu.show()
	TTSManager.say("Menu de configuración abierto")


func _on_ConfigMenu_menu_closed():
	set_overlay()
	$GUI/ConfigMenu.hide()
	TTSManager.say("Menu de configuración cerrado")
	get_tree().paused = false


func _on_Lever_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("ui_click"):
		power_selected = true


func _on_LeftTurnButton_b_pressed():
	current_action = actions_enum.TURN_LEFT


func _on_RightTurnButton_b_pressed():
	current_action = actions_enum.TURN_RIGHT


func _on_TurnButton_button_up():
	current_action = actions_enum.IDLE


func _on_PowerUpButton_b_pressed():
	current_action = actions_enum.POWER_UP


func _on_PowerDownButton_b_pressed():
	current_action = actions_enum.POWER_DOWN


func _on_HomeButton_b_pressed():
	$NoPause/HomePanel.open()
