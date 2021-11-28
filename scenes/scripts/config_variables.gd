extends Node


var overlay_size = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	overlay_size = get_viewport().size.y / 540 * 3

