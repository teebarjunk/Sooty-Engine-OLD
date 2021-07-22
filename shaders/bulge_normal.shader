shader_type canvas_item;

uniform float scale : hint_range(0.0, 64.0) = 2.0;

void fragment() {
	vec2 off = texture(TEXTURE, UV).rg * 2.0 - 1.0;
	off *= SCREEN_PIXEL_SIZE;
	off *= scale;
	vec4 clr = texture(SCREEN_TEXTURE, SCREEN_UV + off);
	
	COLOR.rgb = clr.rgb;
}