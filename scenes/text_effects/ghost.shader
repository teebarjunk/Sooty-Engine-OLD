shader_type canvas_item;
render_mode blend_add;

uniform float t : hint_range(0.0, 1.0) = 0.0;

highp float rand(vec2 co, float seed) {
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot(co + seed, vec2(a, b)), sn = mod(dt, 3.14159);
	return fract(sin(sn) * c + seed);
}

void vertex() {
	vec2 off = vec2(
		rand(VERTEX.xy, 0.12),
		rand(VERTEX.yx, 1.03)
	);
	VERTEX.x += VERTEX.x * t;
	VERTEX += off * t * sin(TIME + VERTEX.x * .01) * 16.0;
	VERTEX.xy /= mix(1.0, 0.8, t);
}

void fragment() {
	COLOR = textureLod(TEXTURE, UV, t * 10.0);
	COLOR.a *= 1.0 - t;
}