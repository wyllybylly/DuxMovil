extends Node2D


var groups_rescued = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelVariables.water_speed = 10.0
	$Boat.update_water_speed()
	$Water.update_water_speed()
	var camera = $Boat/Boat/FollowBoatCamera
	var water_size = $Water.region_rect.size
	camera.limit_bottom = $Water.global_position.y + water_size.y / 2
	camera.limit_top = $Water.global_position.y - water_size.y / 2
	camera.limit_left = $Water.global_position.x - water_size.x / 2
	camera.limit_right = $Water.global_position.x + water_size.x / 2
