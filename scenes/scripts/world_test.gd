extends Node2D


var groups_rescued = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelVariables.water_speed = 10.0
	$Boat.update_water_speed()
	$Water.update_water_speed()
