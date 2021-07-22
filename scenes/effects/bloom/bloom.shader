shader_type canvas_item;
render_mode blend_add;

uniform float scale : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, 2.0);
	vec4 blur = texture(SCREEN_TEXTURE, SCREEN_UV);
	float gray = (blur.r + blur.g + blur.b) / 3.0;
	gray = clamp(pow(gray, scale), 0.0, 1.0);
	COLOR = screen * (1.0 - gray);
}