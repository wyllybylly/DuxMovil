tool
class_name Person
extends KinematicBody2D

enum actions {
	IDLE,
	GETTING_ON_THE_BOAT,
	GETTING_OFF_THE_BOAT,
}

const tex1 = preload("res://levels/level_creation/groups/person/person.png")
const tex2 = preload("res://levels/level_creation/groups/person/person_with_child.png")
const mask1 = preload("res://levels/level_creation/groups/person/person_mask.png")
const mask2 = preload("res://levels/level_creation/groups/person/person_with_child_mask.png")
const spriteMaterial = preload("res://levels/level_creation/groups/person/person_tint.tres")

const hair_colors = ["734c29", "5b4027", "7e5835", "8c752a", "d7b548", "322513", "1d1305", "672616"]
const hair_colors_elder = ["cbcbcb", "a5a5a5", "747474", "4c4c4c", "2c2c2c"]

const idle_scale = Vector2(0.6, 0.6)
const boat_scale = Vector2(0.3, 0.3)
const scale_difference = idle_scale - boat_scale

export (bool) var random_colors = false setget set_random_colors
export (bool) var elder = false setget set_elder
export (bool) var baby = false setget set_baby
export (Color) var hair_color = Color.saddlebrown setget set_hair_color
export (Color) var clothes_color = Color.red setget set_clothes_color
export (Color) var baby_color = Color.green setget set_baby_color

var person_sprite
var person_collision
var action = actions.IDLE
var boat
var seat
var calling_boat
var boat_position
var starting_distance


func _init():
	person_collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.set_radius(16.0)
	person_collision.set_shape(shape)
	add_child(person_collision)
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(5, true)
	set_collision_mask_bit(0, false)
	person_sprite = Sprite.new()
	var mat = spriteMaterial.duplicate()
	person_sprite.set_material(mat)
	add_child(person_sprite)
	set_texture()


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = idle_scale


func _process(delta):
	if action == actions.GETTING_ON_THE_BOAT:
		move_and_slide(boat_position - position)
		var current_distance = position.distance_squared_to(boat_position)
		if current_distance < 200.0:
			rescued()
		else:
			var diff = sqrt(-pow(current_distance / starting_distance - 1, 2) + 1)
			scale = boat_scale + scale_difference * diff


func start_rescue(new_boat, new_seat, new_calling_boat):
	boat = new_boat
	seat = new_seat
	calling_boat = new_calling_boat
	action = actions.GETTING_ON_THE_BOAT
	boat_position = boat.global_position - get_parent().global_position + seat[0]
	starting_distance = position.distance_squared_to(boat_position)
	print(starting_distance)
#	rotation = position.angle_to(boat_position)


func rescued():
	# Notify parent the person has been rescued
	get_parent().person_rescued(self)
	# Change Parent and get in Boat
	boat.add_child(self)
	position = seat[0]
	rotation_degrees = seat[1]
	z_index = 0
	scale = boat_scale
	# Remove collision
	remove_child(person_collision)
	person_collision.queue_free()
	set_collision_layer_bit(5, false)
	action = actions.IDLE
	# Notify boat
	calling_boat.rescue_finished()


func get_to_safe_zone(safe_zone):
	get_parent().remove_child(self)
	safe_zone.add_child(self)
	position = Vector2(rand_range(-50.0, 50.0), rand_range(-15.0, 15.0))
	rotation_degrees = -90.0
	z_index = 3
	scale = idle_scale


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
	var mat = person_sprite.get_material()
	mat.set_shader_param("hair_color",hair_color)


func set_clothes_color(new_color):
	clothes_color = new_color
	var mat = person_sprite.get_material()
	mat.set_shader_param("clothes_color",clothes_color)


func set_baby_color(new_color):
	baby_color = new_color
	var mat = person_sprite.get_material()
	mat.set_shader_param("baby_color",baby_color)


func set_texture():
	var mat = person_sprite.get_material()
	if baby:
		person_sprite.texture = tex2
		mat.set_shader_param("mask_img",mask2)
	else:
		person_sprite.texture = tex1
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
