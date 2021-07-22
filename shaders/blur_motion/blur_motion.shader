shader_type canvas_item;
render_mode blend_mix;

const int SAMPLES = 8;

uniform vec2 velocity;
uniform float spread : hint_range(0.0, 1.0);

void fragment() {
	float l = length(velocity);
	if (l == 0.0) {
		return;
	}
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	float offset = -spread / abs(l - 0.5);
	for (int i = 0; i < SAMPLES-1; i++) {
		float t = float(i) / float(SAMPLES);
		vec2 bias = velocity * t;
		color += texture(SCREEN_TEXTURE, SCREEN_UV + bias * SCREEN_PIXEL_SIZE);
	}
	COLOR = color / float(SAMPLES);
}