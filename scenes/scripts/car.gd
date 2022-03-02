tool
extends Sprite


export (Color) var car_color = Color.cornflower setget set_car_color;
export (Texture) var mask_texture setget set_mask_texture;


# Called when the node enters the scene tree for the first time.
func _ready():
	var mat = self.get_material().duplicate()
	mat.set_shader_param("tint_color",car_color)
	self.set_material(mat)

func set_car_color(new_color):
	car_color = new_color
	var mat = self.get_material()
	mat.set_shader_param("tint_color",car_color)

func set_mask_texture(new_tex):
	mask_texture = new_tex
	var mat = self.get_material()
	mat.set_shader_param("mask_img",mask_texture)
