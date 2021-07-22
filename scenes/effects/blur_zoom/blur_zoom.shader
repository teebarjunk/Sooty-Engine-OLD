shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float power : hint_range(0.0, 1.0) = 0.5;
uniform float radius : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 color = vec4(0, 0, 0, 0);
	float total = 0.0;
	vec2 velocity = SCREEN_UV - center;
	float x = smoothstep(0.5, 1.0, length(velocity) / radius);
	for (int j = 0; j < 8; j++) {
		float t = float(j) / 8.0;
		float w = 1.0 * (t - t * t);
		float p = 1.0 - power * t * x;
		color += textureLod(SCREEN_TEXTURE, center + velocity * p, x * power * 6.0) * w;
		total += w;
	}
	color /= total;
	COLOR = color;
}