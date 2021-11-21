shader_type canvas_item;

uniform vec4 tint_color : hint_color;
uniform sampler2D mask_img;

void fragment(){
    vec4 tex=texture(TEXTURE,UV); //sprite texture
	vec3 color = tint_color.rgb;
    vec3 sprite_color= tex.rgb; //sprite color, without alpha;
	float mask_value = texture(mask_img, UV).a;
	
	if (mask_value == 1.0) {
    	COLOR = vec4( color * sprite_color.r, tex.a );
	}
	else {
		COLOR = tex;
	}

}