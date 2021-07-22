shader_type canvas_item;
//render_mode blend_mix;

uniform float r_blur : hint_range(0.0, 4.0) = 1.0;
uniform float g_blur : hint_range(0.0, 4.0) = 1.5;
uniform float b_blur : hint_range(0.0, 4.0) = 0.0;

uniform vec2 r_offset = vec2(1.0, 0.0);
uniform vec2 g_offset = vec2(-1.0, 0.0);
uniform vec2 b_offset = vec2(0.0, 0.0);

void fragment() {
	float r = textureLod(SCREEN_TEXTURE, SCREEN_UV + r_offset * SCREEN_PIXEL_SIZE, r_blur).r;
	float g = textureLod(SCREEN_TEXTURE, SCREEN_UV + g_offset * SCREEN_PIXEL_SIZE, g_blur).g;
	float b = textureLod(SCREEN_TEXTURE, SCREEN_UV + b_offset * SCREEN_PIXEL_SIZE, b_blur).b;
	COLOR.rgb = vec3(r, g, b);
	COLOR.a = .5;
}