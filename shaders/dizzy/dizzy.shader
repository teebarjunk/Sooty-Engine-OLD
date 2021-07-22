shader_type canvas_item;

uniform float dist_x : hint_range(0.0, 64.0) = 16.0;
uniform float dist_y : hint_range(0.0, 64.0) = 16.0;
uniform float blur : hint_range(0.0, 4.0) = 0.5;

void fragment() {
	vec2 off = vec2(sin(TIME), cos(TIME)) * vec2(dist_x, dist_y) * SCREEN_PIXEL_SIZE;
	vec4 sample1 = textureLod(SCREEN_TEXTURE, SCREEN_UV + off, blur);
	vec4 sample2 = textureLod(SCREEN_TEXTURE, SCREEN_UV - off, blur);
	COLOR = (sample1 + sample2) * .5;
	COLOR.a = .5;
}