extends Node2D


export (int) var priority = 1
export (int) var base_points = 100

var centroid = Vector2.ZERO
var c = 0


func _ready():
	$Signs.set_num_of_people(get_child_count() - 1)
	calculate_centroid()
	$Signs.rect_position = centroid - Vector2($Signs.box_size.x / 2.0, 0.0)


func person_rescued(person):
	remove_child(person)
	$Signs.set_num_of_people($Signs.num_of_people - 1)
	if get_children().size() == 1:
		# Give points (TO IMPLEMENT)
		# Destruir Sign y Group
		get_child(0).queue_free()
		queue_free()
	if person.elder:
		check_elder_exist()
	if person.baby:
		check_baby_exist()


func calculate_centroid():
	var centroid_aux = Vector2.ZERO
	var lowest_point = -9999999.0
	for i in range(get_child_count()):
		if get_child(i) is Person:
			centroid_aux += get_child(i).position
			if get_child(i).position.y > lowest_point:
				lowest_point = get_child(i).position.y
	centroid_aux = centroid_aux / get_child_count()
	centroid_aux.y = lowest_point + 50
	centroid = centroid_aux


func check_elder_exist():
	var exist = false
	for i in range(1, get_child_count()):
		if get_child(i).elder:
			exist = true
			break
	$Signs.set_sign_elder(exist)


func check_baby_exist():
	var exist = false
	for i in range(1, get_child_count()):
		if get_child(i).baby:
			exist = true
			break
	$Signs.set_sign_baby(exist)
