extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelVariables.water_speed = 15.0
	$Boat.update_water_speed()
	$Water.update_water_speed()
