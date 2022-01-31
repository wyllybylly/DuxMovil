shader_type canvas_item;

uniform vec2 position;
uniform float radius;
uniform float aspect_ratio;
uniform vec2 rect_size;
uniform int type;

float distance_circle(vec2 uv) {
	uv.x = uv.x / aspect_ratio;
	vec2 d = vec2(uv.x - position.x, uv.y - position.y);
	float result = sqrt(pow(d.x, 2.0) + pow(d.y, 2.0));
	if (result < radius) {
		return 0.0;
	}
	return 1.0;
}

float distance_rectangle(vec2 uv) {
	if (uv.x < position.x - rect_size.x / 2.0 || uv.x > position.x + rect_size.x / 2.0 || uv.y < position.y - rect_size.y / 2.0 || uv.y > position.y + rect_size.y / 2.0) {
		return 1.0;
	}
	return 0.0;
}

void fragment() {
	float result = 0.0;
	if (type == 1) {
		result = distance_circle(UV);
	}
	else if (type == 2) {
		result = distance_rectangle(UV);
	}
	if (result != 0.0) {
		COLOR = vec4(0.3, 0.3, 0.3, 0.3)
	}
	else {
		COLOR.a = 0.0
	}
}