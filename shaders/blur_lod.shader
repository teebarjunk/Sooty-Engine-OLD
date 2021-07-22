shader_type canvas_item;

// REQUIRES MIP MAPS

uniform float blur : hint_range (0, 16.0);
uniform float gray : hint_range (0, 1.0);

vec3 grayscale(vec3 color) {
	return vec3(dot(color, vec3(0.2126, 0.7152, 0.0722)));
}

void fragment() {
	COLOR = textureLod(TEXTURE, UV, blur);
	COLOR.rgb = mix(COLOR.rgb, grayscale(COLOR.rgb), gray);
}