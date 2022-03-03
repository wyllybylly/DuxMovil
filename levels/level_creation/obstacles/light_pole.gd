tool
extends StaticBody2D


export (String, "Normal", "WL1", "Electric") var type = "Electric" setget set_type


func set_type(new_type):
	type = new_type
	if get_child_count() > 0:
		$Sprite.stop()
		if type == "Normal":
			$Sprite.animation = "Normal"
			$Sprite.frame = 0
		elif type == "WL1":
			$Sprite.animation = "Normal"
			$Sprite.frame = 1
		else:
			$Sprite.animation = "Electric"
			$Sprite.play()


func _on_Sprite_animation_finished():
	$Timer.start()
	$Sprite.stop()


func _on_Timer_timeout():
	if type == "Electric":
		$Sprite.play()
