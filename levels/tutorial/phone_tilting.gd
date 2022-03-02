extends Sprite


var direction = 1


func _process(delta):
	if direction == 1 and rotation_degrees >= -70.0:
		direction = -1
	elif direction == -1 and rotation_degrees <= -110.0:
		direction = 1
	set_rotation(get_rotation() + direction * delta * 0.5)
