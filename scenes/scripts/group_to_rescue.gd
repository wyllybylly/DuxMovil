extends Node2D


export (int) var priority = 1
export (int) var base_points = 100


func _ready():
	pass


func person_rescued(person):
	remove_child(person)
	if get_children().size() == 1:
		# Give points (TO IMPLEMENT)
		# Destruir Sign y Group
		get_child(0).queue_free()
		queue_free()
