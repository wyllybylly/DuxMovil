extends Node2D


export (float) var max_speed = 20

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
var anchored = false
var max_seats = 15
var used_seats = 0
var from_point
var to_point
var rope_color
var rope_lenght
var stabilizing


func _draw():
	draw_line(from_point, to_point, rope_color)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize overlay positions
	var mid_height = get_viewport().size.y / 2.0
	$GUI/Frame.position = Vector2(get_viewport().size.x - 30.0 * ConfigVariables.get_overlay_size(), mid_height)
	$GUI/Lever.position = Vector2(get_viewport().size.x - 30.0 * ConfigVariables.get_overlay_size(), mid_height + 48 * ConfigVariables.get_overlay_size())
	$GUI/AnchorButton.position = Vector2(30.0 * ConfigVariables.get_overlay_size(), get_viewport().size.y - 30 * ConfigVariables.get_overlay_size())
	$GUI/RescueButton.position = Vector2(30.0 * ConfigVariables.get_overlay_size(), get_viewport().size.y - 80 * ConfigVariables.get_overlay_size())
	$GUI/Lever/LeverSprite.position = Vector2.ZERO
	$GUI/Lever/LeverCollision.position = Vector2.ZERO
	$GUI/AnchorButton/AnchorSprite.position = Vector2.ZERO
	$GUI/AnchorButton/AnchorCollision.position = Vector2.ZERO
	$GUI/RescueButton/RescueSprite.position = Vector2.ZERO
	$GUI/RescueButton/RescueCollision.position = Vector2.ZERO
	lever_height = Vector2($GUI/Lever.position.y, 96 * ConfigVariables.get_overlay_size())
	$GUI/Lever.scale = Vector2(ConfigVariables.get_overlay_size(),ConfigVariables.get_overlay_size())
	$GUI/Frame.scale = Vector2(ConfigVariables.get_overlay_size(),ConfigVariables.get_overlay_size())
	$GUI/AnchorButton.scale = Vector2(ConfigVariables.get_overlay_size() * 1.2,ConfigVariables.get_overlay_size() * 1.2)
	$GUI/RescueButton.scale = Vector2(ConfigVariables.get_overlay_size() * 1.2,ConfigVariables.get_overlay_size() * 1.2)
	$GUI/Lever/LeverSprite.modulate.a = ConfigVariables.overlay_alpha
	$GUI/Frame.modulate.a = ConfigVariables.overlay_alpha
	$GUI/AnchorButton/AnchorSprite.modulate.a = ConfigVariables.overlay_alpha
	$GUI/RescueButton/RescueSprite.modulate.a = ConfigVariables.overlay_alpha
	
	# Initialize water speed
	water_speed = LevelVariables.water_speed
	
	# Initialize rope variables
	from_point = Vector2.ZERO
	to_point = Vector2.ZERO
	rope_color = Color.darkgray


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not anchored:
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


func _on_Lever_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("ui_click"):
		power_selected = true


func _on_AnchorButton_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if anchored:
				anchored = false
				from_point = to_point
				update()
			else:
				if not $Boat/AnchorageArea.get_overlapping_bodies().empty():
					anchored = true
					from_point = Vector2($Boat.position.x + sin($Boat.rotation) * 75.0, $Boat.position.y + cos($Boat.rotation) * -75.0)
					to_point = $Boat/AnchorageArea.get_overlapping_bodies().pop_front().global_position - global_position
					rope_lenght = from_point.distance_to(to_point)
					update()
					stabilizing = true


func _on_RescueButton_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if anchored:
				# If there is a person to rescue, rescue them
				if not $Boat/RescueArea.get_overlapping_areas().empty():
					var person = $Boat/RescueArea.get_overlapping_areas().pop_front()
					var seat = get_seat()
					if seat != null:
						person.rescued($Boat, seat)
				# If there is a safe zone, leave a person on  it
				elif not $Boat/SafeZoneArea.get_overlapping_areas().empty():
					var safe_zone = $Boat/SafeZoneArea.get_overlapping_areas().pop_front()
					var person = get_person()
					if person != null:
						person.get_to_safe_zone(safe_zone)
						emit_signal("person_safe")
				# Else do nothing


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


func rotate(delta):
	$Boat.rotate(PI / 4 * delta)


func stabilize_rotation(delta):
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
