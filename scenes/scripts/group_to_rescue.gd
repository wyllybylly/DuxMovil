extends Node2D


export (int) var priority = 1
export (int) var base_points = 100

var centroid = Vector2.ZERO
var c = 0


func _ready():
	$Signs.set_num_of_people(get_child_count() - 1)
	calculate_centroid()
	$Signs.position = centroid + Vector2(-$Signs.box_size.x / 2, -$Signs.box_size.y - 60.0)


func person_rescued(person):
	remove_child(person)
	$Signs.set_num_of_people($Signs.num_of_people - 1)
	if get_children().size() == 1:
		# Give points (TO IMPLEMENT)
		# Destruir Sign y Group
		get_child(0).queue_free()
		queue_free()


func calculate_centroid():
	var centroid_aux = Vector2.ZERO
	for i in range(get_child_count()):
		if get_child(i) is Area2D:
			centroid_aux += get_child(i).position
	centroid_aux = centroid_aux / get_child_count()
	centroid = centroid_aux
