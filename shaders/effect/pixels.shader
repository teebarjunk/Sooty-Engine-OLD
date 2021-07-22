shader_type canvas_item;

uniform float pixel_size : hint_range(0.1, 256) = 32.0;

void fragment() {
	vec2 uv = (SCREEN_UV - .5) * pixel_size + .5;
	vec4 icon = texture(TEXTURE, uv) * 2.0;
	
	vec2 suv = round(SCREEN_UV * pixel_size) / pixel_size;
	vec4 bg = texture(SCREEN_TEXTURE, suv) * icon;
	COLOR = bg;
}