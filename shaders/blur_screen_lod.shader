shader_type canvas_item;
//render_mode blend_premul_alpha;

uniform float blur : hint_range(0, 32.0) = 2.0;

void fragment() {
	COLOR *= textureLod(SCREEN_TEXTURE, SCREEN_UV, blur);
}