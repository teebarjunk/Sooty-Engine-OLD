shader_type canvas_item;

uniform float radius;
uniform float strength;
uniform vec2 center;

void fragment() {
	vec2 coord = SCREEN_UV;
	coord -= center;
	float d = length(coord);
	if (d < radius) {
		float percent = d / radius;
		if (strength > 0.0) {
			coord *= mix(1.0, smoothstep(0.0, radius / d, percent), strength);
		} else {
			coord *= mix(1.0, pow(percent, 1.0 + strength) * radius / d, 1.0 - percent);
		}
	}
	coord += center;
	COLOR = texture(SCREEN_TEXTURE, coord);
}