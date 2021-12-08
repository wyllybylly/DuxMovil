extends Node2D


export (float) var max_speed = 20

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


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize overlay positions
	var mid_height = get_viewport().size.y / 2.0
	$Frame.position = Vector2(get_viewport().size.x - 30.0 * ConfigVariables.get_overlay_size(), mid_height)
	$Lever.position = Vector2(get_viewport().size.x - 30.0 * ConfigVariables.get_overlay_size(), mid_height + 48 * ConfigVariables.get_overlay_size())
	$AnchorButton.position = Vector2(30.0 * ConfigVariables.get_overlay_size(), get_viewport().size.y - 30 * ConfigVariables.get_overlay_size())
	$RescueButton.position = Vector2(30.0 * ConfigVariables.get_overlay_size(), get_viewport().size.y - 80 * ConfigVariables.get_overlay_size())
	$Lever/LeverSprite.position = Vector2.ZERO
	$Lever/LeverCollision.position = Vector2.ZERO
	$AnchorButton/AnchorSprite.position = Vector2.ZERO
	$AnchorButton/AnchorCollision.position = Vector2.ZERO
	$RescueButton/RescueSprite.position = Vector2.ZERO
	$RescueButton/RescueCollision.position = Vector2.ZERO
	lever_height = Vector2($Lever.position.y, 96 * ConfigVariables.get_overlay_size())
	$Lever.scale = Vector2(ConfigVariables.get_overlay_size(),ConfigVariables.get_overlay_size())
	$Frame.scale = Vector2(ConfigVariables.get_overlay_size(),ConfigVariables.get_overlay_size())
	$AnchorButton.scale = Vector2(ConfigVariables.get_overlay_size() * 1.2,ConfigVariables.get_overlay_size() * 1.2)
	$RescueButton.scale = Vector2(ConfigVariables.get_overlay_size() * 1.2,ConfigVariables.get_overlay_size() * 1.2)
	$Lever/LeverSprite.modulate.a = ConfigVariables.overlay_alpha
	$Frame.modulate.a = ConfigVariables.overlay_alpha
	$AnchorButton/AnchorSprite.modulate.a = ConfigVariables.overlay_alpha
	$RescueButton/RescueSprite.modulate.a = ConfigVariables.overlay_alpha
	
	# Initialize water speed
	water_speed = LevelVariables.water_speed


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


func _on_Lever_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("ui_click"):
		power_selected = true


func _on_AnchorButton_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if anchored:
				anchored = false
			else:
				if not $Boat/AnchorageArea.get_overlapping_bodies().empty():
					anchored = true


func _on_RescueButton_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			# If there is a person to rescue, rescue them
			if anchored and not $Boat/RescueArea.get_overlapping_areas().empty():
				var person = $Boat/RescueArea.get_overlapping_areas().pop_front()
				person.rescued($Boat, get_seat())
			# Else do nothing


func _physics_process(delta):
	if power_selected:
		if get_global_mouse_position().y < $Lever.position.y:
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


func update_lever_y():
	$Lever.position.y = lever_height.x - (speed / max_speed) * lever_height.y


func update_water_speed():
	water_speed = LevelVariables.water_speed


func get_seat():
	if max_seats > used_seats:
		used_seats += 1
		# Get position and rotation to seat
		return SEATS[used_seats - 1]
