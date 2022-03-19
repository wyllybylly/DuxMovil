extends Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	self.material.set_shader_param("noise_speed",LevelVariables.water_speed / 3.0)
	SoundManager.play_bgs("water_stream")
#	region_rect = Rect2(0, 0, get_viewport().size.x, get_viewport().size.y)
#	position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)


func update_water_speed():
	self.material.set_shader_param("noise_speed",LevelVariables.water_speed / 3.0)

