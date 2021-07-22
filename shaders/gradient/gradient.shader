shader_type canvas_item;
render_mode blend_mul;

uniform vec4 color_t : hint_color = vec4(1, 1, 1, 1);
uniform vec4 color_b : hint_color = vec4(0, 0, 0, 1);
uniform float t : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 off = texture(TEXTURE, UV).rg * 2.0 - 1.0;
	COLOR = screen * mix(color_t, color_b, smoothstep(t, 1.0, UV.y));
}