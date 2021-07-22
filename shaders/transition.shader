shader_type canvas_item;

uniform float fade : hint_range(0.0, 1.0) = 0.0;
uniform float size : hint_range(0.0, 0.1) = 0.01;

float remap(float t, float in_min, float in_max, float out_min, float out_max) {
	return (t - in_min) / (in_max - in_min) * (out_max - out_min) + out_min;
}
void fragment() {
	float color = texture(TEXTURE, UV).r;
	color = remap(color, -size, 1.0 + size, 0.0, 1.0);
	color = 1.0 - smoothstep(fade-size, fade+size, color);
	COLOR = vec4(color, color, color, color);
}