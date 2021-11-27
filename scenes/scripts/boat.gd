extends Node2D


export (float) var max_velocity = 20

var velocity = 0.0
var water_velocity = 10.0
var lever_height = Vector2(0,0) # [0] min pos, [1] max movement
var selected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var mid_height = get_viewport().size.y / 2.0
	$Frame.position = Vector2(get_viewport().size.x - 50.0 * ConfigVariables.overlay_size, mid_height)
	$Lever.position = Vector2(get_viewport().size.x - 50.0 * ConfigVariables.overlay_size, mid_height + 48 * ConfigVariables.overlay_size)
	$Lever/LeverSprite.position = Vector2.ZERO
	$Lever/LeverCollision.position = Vector2.ZERO
	lever_height = Vector2($Lever.position.y, 96 * ConfigVariables.overlay_size)
	$Lever.scale = Vector2(ConfigVariables.overlay_size,ConfigVariables.overlay_size)
	$Frame.scale = Vector2(ConfigVariables.overlay_size,ConfigVariables.overlay_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		power_up(delta)
	if Input.is_action_pressed("ui_down"):
		power_down(delta)
	if Input.is_action_pressed("ui_right") and velocity != 0.0:
		$Boat.rotate(PI / 4 * delta)
	if Input.is_action_pressed("ui_left") and velocity != 0.0:
		$Boat.rotate(- PI / 4 * delta)
	var movement = Vector2()
	if velocity != 0.0:
		movement += Vector2(1, 0).rotated($Boat.rotation - PI / 2) * velocity
	movement.y += water_velocity
	$Boat.position += movement * delta * 10


func _on_Lever_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("ui_click"):
		selected = true


func _physics_process(delta):
	if selected:
		if get_global_mouse_position().y < $Lever.position.y:
			power_up(delta)
		else:
			power_down(delta)


func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false


func power_up(delta):
	velocity = min(velocity + 20.0 * delta, max_velocity)
	update_lever_y()


func power_down(delta):
	velocity = max(velocity - 20.0 * delta, 0)
	update_lever_y()


func update_lever_y():
	$Lever.position.y = lever_height.x - (velocity / max_velocity) * lever_height.y


