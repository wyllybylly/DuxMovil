tool
class_name GroupSign
extends TextureButton


export (bool) var reset = false setget reset_signs
export (bool) var sign_baby = false setget set_sign_baby
export (bool) var sign_elder = false setget set_sign_elder
export (bool) var sign_disability = false setget set_sign_disability
export (bool) var sign_flooded = false setget set_sign_flooded
export (bool) var sign_stairs = false setget set_sign_stairs
export (int) var num_of_people = 0 setget set_num_of_people

var box_radius = 16
var box_position = Vector2.ZERO
var box_size = Vector2(16, 80)
var sign_baby_texture = preload("res://resources/rescue/sign_baby.png")
var sign_elder_texture = preload("res://resources/rescue/sign_elder.png")
var sign_disability_texture = preload("res://resources/rescue/sign_disability.png")
var sign_flooded_texture = preload("res://resources/rescue/sign_flooded.png")
var sign_stairs_texture = preload("res://resources/rescue/sign_stairs.png")
var sign_no_stairs_texture = preload("res://resources/rescue/sign_no_stairs.png")
var sign_person_1_texture = preload("res://resources/rescue/sign_person_1.png")
var sign_person_2_texture = preload("res://resources/rescue/sign_person_2.png")
var sign_person_3_texture = preload("res://resources/rescue/sign_person_3.png")


func _draw():
	var style_box = StyleBoxFlat.new()
	style_box.set_corner_radius_all(box_radius)
	style_box.bg_color = Color(0.6, 0.6, 0.6, 0.75)
	style_box.border_color = Color(0.16, 0.16, 0.16, 1.0)
	style_box.set_border_width_all(2)
	draw_style_box(style_box, Rect2(box_position, box_size))


func reset_signs(new_value):
	if new_value:
		for child in self.get_children():
			child.queue_free()
		box_size = Vector2(16, 80)
		rect_size = box_size
		update()
	reset = false


func set_sign_baby(new_value):
	sign_baby = new_value
	if new_value:
		add_sign("SignBaby", sign_baby_texture)
	else:
		remove_sign("SignBaby")


func set_sign_elder(new_value):
	sign_elder = new_value
	if new_value:
		add_sign("SignElder", sign_elder_texture)
	else:
		remove_sign("SignElder")


func set_sign_disability(new_value):
	sign_disability = new_value
	if new_value:
		add_sign("SignDisability", sign_disability_texture)
	else:
		remove_sign("SignDisability")


func set_sign_flooded(new_value):
	sign_flooded = new_value
	if new_value:
		add_sign("SignFlooded", sign_flooded_texture)
	else:
		remove_sign("SignFlooded")


func set_sign_stairs(new_value):
	sign_stairs = new_value
	if new_value:
		change_sign_texture("SignStair",sign_stairs_texture)
	else:
		change_sign_texture("SignStair",sign_no_stairs_texture)


func set_num_of_people(new_value):
	num_of_people = new_value
	if new_value == 0:
		remove_sign("SignPeople")
	elif new_value == 1:
		change_sign_texture("SignPeople",sign_person_1_texture)
	elif new_value == 2:
		change_sign_texture("SignPeople",sign_person_2_texture)
	else:
		change_sign_texture("SignPeople",sign_person_3_texture)


func add_sign(name, texture):
	var sign_sprite = Sprite.new()
	sign_sprite.texture = texture
	sign_sprite.name = name
	sign_sprite.position = Vector2(64 * self.get_child_count() + 40, 40)
	self.add_child(sign_sprite)
	sign_sprite.set_owner(self)
	box_size.x += 64
	rect_size = box_size
	update()


func change_sign_texture(name, texture):
	var already_exists = false
	for child in self.get_children():
		if child.name == name:
			already_exists = true
			child.texture = texture
			break
	if not already_exists:
		add_sign(name, texture)


func remove_sign(name):
	for child in self.get_children():
		if child.name == name:
			var index = child.get_index()
			for i in range(index, self.get_child_count()):
				self.get_child(i).position = Vector2(64 * (i - 1) + 40, 40)
			child.queue_free()
			box_size.x -= 64
			rect_size = box_size
			update()
			break


func _on_Signs_pressed():
	if TTSManager.is_on():
		var text = "Grupo de personas a rescatar. "
		if sign_baby == true:
			text += "Hay bebés. "
		if sign_elder == true:
			text += "Hay personas mayores. "
		if sign_disability == true:
			text += "Hay personas con discapacidad. "
		if sign_flooded == true:
			text += "El agua es demasiado alta. "
		if sign_stairs == true:
			text += "Tienen techo o planta alta. "
		else:
			text += "No tienen techo ni planta alta. "
		if num_of_people == 1:
			text += "Queda una persona."
		elif num_of_people == 2:
			text += "Quedan dos personas."
		else:
			text += "Quedan tres o más personas."
		TTSManager.say(text)
