extends Node2D


export (String) var node_path;
export (String, "Circle", "Rectangle") var poly_type;


func _draw():
	draw_rect(get_viewport_rect(), Color(0.5, 0.5, 0.5, 0.5))


# Called when the node enters the scene tree for the first time.
func _ready():
	if poly_type == "Circle":
		var vs = get_viewport_rect().size
		var ar = vs.y / vs.x
		var mat = self.get_material()
		mat.set_shader_param("type", 1)
		mat.set_shader_param("aspect_ratio", ar)
		var button = get_node(node_path)
		var pos = button.global_position
		print(pos)
		pos.x = pos.x / vs.x / ar
		pos.y = pos.y / vs.y
		print(pos)
		mat.set_shader_param("position", pos)
		var radius = button.get_child(0).get_rect().size.x / vs.x * button.scale.x * 1.1
		mat.set_shader_param("radius", radius)
	elif poly_type == "Rectangle":
		var vs = get_viewport_rect().size
		var ar = vs.y / vs.x
		var mat = self.get_material()
		mat.set_shader_param("type", 2)
		var button = get_node(node_path)
		var rect_size = button.get_rect().size * button.scale.x * 1.35
		rect_size.x = rect_size.x / vs.x
		rect_size.y = rect_size.y / vs.y
		mat.set_shader_param("rect_size", rect_size)
		var pos = button.global_position
		pos.x = pos.x / vs.x
		pos.y = pos.y / vs.y
		mat.set_shader_param("position", pos)
