tool
extends TileMap


export (Color) var house_color = Color.beige setget set_house_color;
export (float) var mix_amount = 1.0 setget set_mix_amount;


# Called when the node enters the scene tree for the first time.
func _ready():
	var mat = self.get_material().duplicate()
	mat.set_shader_param("house_color",house_color)
	self.set_material(mat)

func set_house_color(new_color):
	house_color = new_color
	var mat = self.get_material()
	mat.set_shader_param("house_color",house_color)


func set_mix_amount(new_amount):
	mix_amount = new_amount
	var mat = self.get_material()
	mat.set_shader_param("mix_amount",mix_amount)
