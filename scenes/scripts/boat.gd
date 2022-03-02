extends Node2D


export (float) var max_speed = 40

signal person_safe


const SEATS = [
	[Vector2(0, -50), 90],
	[Vector2(15, -45), 135],
	[Vector2(-15, -45), 45],
	[Vector2(20, -30), 0],
	[Vector2(-20, -30), 0],
	[Vector2(0, -35), 90],
	[Vector2(0, -20), 90],
	[Vector2(20, -12.5), 0],
	[Vector2(-20, -12.5), 0],
	[Vector2(20, 5), 0],
	[Vector2(-20, 5), 0],
	[Vector2(20, 22.5), 0],
	[Vector2(-20, 22.5), 0],
	[Vector2(20, 40), 0],
	[Vector2(-20, 40), 0],
]

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


func _draw():
	draw_line(from_point, to_point, rope_color, 2.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize overlay positions
	set_overlay()
	
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
		if Input.is_action_pressed("ui_up"):
			power_up(delta)
		if Input.is_action_pressed("ui_down"):
			power_down(delta)
		if Input.is_action_pressed("ui_right") and speed != 0.0:
			rotate(delta)
		if Input.is_action_pressed("ui_left") and speed != 0.0:
			rotate(-delta)
		if Input.get_accelerometer().x > 3.0:
			rotate(delta)
		if Input.get_accelerometer().x < -3.0:
			rotate(-delta)
		var movement = Vector2()
		if speed != 0.0:
			movement += Vector2(1, 0).rotated($Boat.rotation - PI / 2) * speed
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
	$GUI/Lever.position.y = lever_height.x - (speed / max_speed) * lever_height.y


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
	var mid_height = get_viewport().size.y / 2.0
	$GUI/Frame.position = Vector2(get_viewport().size.x - 30.0 * ConfigVariables.get_overlay_size(), mid_height)
	$GUI/Lever.position = Vector2(get_viewport().size.x - 30.0 * ConfigVariables.get_overlay_size(), mid_height + 48 * ConfigVariables.get_overlay_size())
	$GUI/DockButton.rect_position = Vector2(20.0, get_viewport().size.y - 15.0 * ConfigVariables.get_overlay_size() - 110.0)
	$GUI/RescueButton.rect_position = Vector2(20.0, get_viewport().size.y - 35.0 * ConfigVariables.get_overlay_size() - 200.0)
	$GUI/OptionsButton.rect_position = Vector2(get_viewport().size.x - (40.0 * ConfigVariables.get_overlay_size() + 200.0 if ConfigVariables.get_overlay_size() >= 3 else 20.0 * ConfigVariables.get_overlay_size() + 100.0), 10.0)
	$GUI/Lever/LeverSprite.position = Vector2.ZERO
	$GUI/Lever/LeverCollision.position = Vector2.ZERO
	lever_height = Vector2($GUI/Lever.position.y, 96 * ConfigVariables.get_overlay_size())
	$GUI/Lever.scale = Vector2(ConfigVariables.get_overlay_size(),ConfigVariables.get_overlay_size())
	$GUI/Frame.scale = Vector2(ConfigVariables.get_overlay_size(),ConfigVariables.get_overlay_size())
	var scale_value = 1.4 + ConfigVariables.get_overlay_size() * 0.2
	$GUI/DockButton.rect_scale = Vector2(scale_value, scale_value)
	$GUI/RescueButton.rect_scale = Vector2(scale_value, scale_value)
	$GUI/OptionsButton.rect_scale = Vector2(scale_value, scale_value)
	$GUI/Lever/LeverSprite.modulate.a = ConfigVariables.overlay_alpha
	$GUI/Frame.modulate.a = ConfigVariables.overlay_alpha
	$GUI/DockButton.modulate.a = ConfigVariables.overlay_alpha
	$GUI/RescueButton.modulate.a = ConfigVariables.overlay_alpha
	$GUI/OptionsButton.modulate.a = ConfigVariables.overlay_alpha


func _on_DockButton_b_pressed():
	# If boat is docked, undock it
	if docked:
		docked = false
		from_point = to_point
		update()
		TTSManager.say("Lancha suelta")
	# Else, check if there is dockable areas
	else:
		# If there is, dock
		if not $Boat/DockArea.get_overlapping_bodies().empty():
			docked = true
			from_point = Vector2($Boat.position.x + sin($Boat.rotation) * 75.0, $Boat.position.y + cos($Boat.rotation) * -75.0)
			to_point = $Boat/DockArea.get_overlapping_bodies().pop_front().global_position - global_position
			rope_lenght = from_point.distance_to(to_point)
			update()
			stabilizing = true
			TTSManager.say("Lancha anclada")
		# Else notify
		else:
			TTSManager.say("No se encontró lugar para anclar")


func _on_RescueButton_b_pressed():
	if docked:
		# If there is a person to rescue, rescue them
		if not $Boat/RescueArea.get_overlapping_areas().empty():
			var person = $Boat/RescueArea.get_overlapping_areas().pop_front()
			var seat = get_seat()
			if seat != null:
				person.rescued($Boat, seat)
				TTSManager.say("Se subió una persona a la lancha")
			else:
				TTSManager.say("No hay más lugar en la lancha")
		# If there is a safe zone, leave a person on  it
		elif not $Boat/SafeZoneArea.get_overlapping_areas().empty():
			var safe_zone = $Boat/SafeZoneArea.get_overlapping_areas().pop_front()
			var person = get_person()
			if person != null:
				person.get_to_safe_zone(safe_zone)
				emit_signal("person_safe")
				TTSManager.say("Se dejó una persona en zona segura")
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
