tool
class_name Person
extends Area2D


const tex1 = preload("res://resources/rescue/person.png")
const tex2 = preload("res://resources/rescue/person_with_child.png")
const mask1 = preload("res://resources/rescue/person_mask.png")
const mask2 = preload("res://resources/rescue/person_with_child_mask.png")
const spriteMaterial = preload("res://resources/shaders/person_tint.tres")

const hair_colors = ["734c29", "5b4027", "7e5835", "8c752a", "d7b548", "322513", "1d1305", "672616"]
const hair_colors_elder = ["cbcbcb", "a5a5a5", "747474", "4c4c4c", "2c2c2c"]

export (bool) var random_colors = false setget set_random_colors
export (bool) var elder = false setget set_elder
export (bool) var baby = false setget set_baby
export (Color) var hair_color = Color.saddlebrown setget set_hair_color
export (Color) var clothes_color = Color.red setget set_clothes_color
export (Color) var baby_color = Color.green setget set_baby_color

var personSprite
var personCollision


func _init():
	personCollision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.set_radius(16.0)
	personCollision.set_shape(shape)
	add_child(personCollision)
	personSprite = Sprite.new()
	var mat = spriteMaterial.duplicate()
	personSprite.set_material(mat)
	add_child(personSprite)
	set_texture()


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0.6, 0.6)


func rescued(boat, seat):
	# Notify parent the person has been rescued
	get_parent().person_rescued(self)
	# Change Parent and get in Boat
	boat.add_child(self)
	position = seat[0]
	rotation_degrees = seat[1]
	z_index = 0
	scale = Vector2(0.4, 0.4)
	# Remove collision
	personCollision.queue_free()


func get_to_safe_zone(safe_zone):
	get_parent().remove_child(self)
	safe_zone.add_child(self)
	position = Vector2(rand_range(-50.0, 50.0), rand_range(-50.0, 50.0))
	rotation_degrees = 0.0
	z_index = 1
	scale = Vector2(0.6, 0.6)


func set_sprite():
	# Set colors
	var color
	if !elder:
		color = Color(hair_colors[randi() % hair_colors.size()])
	else:
		color = Color(hair_colors_elder[randi() % hair_colors_elder.size()])
	set_hair_color(color)
	color = Color(randf(), randf(), randf())
	set_clothes_color(color)
	set_texture()
	if baby:
		color = Color(randf(), randf(), randf())
		set_baby_color(color)


func set_hair_color(new_color):
	hair_color = new_color
	var mat = personSprite.get_material()
	mat.set_shader_param("hair_color",hair_color)


func set_clothes_color(new_color):
	clothes_color = new_color
	var mat = personSprite.get_material()
	mat.set_shader_param("clothes_color",clothes_color)


func set_baby_color(new_color):
	baby_color = new_color
	var mat = personSprite.get_material()
	mat.set_shader_param("baby_color",baby_color)


func set_texture():
	var mat = personSprite.get_material()
	if baby:
		personSprite.texture = tex2
		mat.set_shader_param("mask_img",mask2)
	else:
		personSprite.texture = tex1
		mat.set_shader_param("mask_img",mask1)


func set_random_colors(new_value):
	if new_value:
		set_sprite()
	random_colors = false


func set_elder(new_value):
	elder = new_value
	var color
	if !elder:
		color = Color(hair_colors[randi() % hair_colors.size()])
	else:
		color = Color(hair_colors_elder[randi() % hair_colors_elder.size()])
	set_hair_color(color)


func set_baby(new_value):
	baby = new_value
	set_texture()
	if baby:
		var color = Color(randf(), randf(), randf())
		set_baby_color(color)
