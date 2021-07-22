shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float power : hint_range(0.0, 1.0) = 0.5;

highp float rand(vec2 co, float seed) {
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot(co + seed, vec2(a, b)), sn = mod(dt, 3.14159);
	return fract(sin(sn) * c + seed);
}

void fragment() {
	vec4 color = vec4(0.0);
	float total = 0.0;
	vec2 velocity = (center - UV);
	float offset = rand(UV, 12.9898);
	
	float dist_scale = length(UV - vec2(0.5));
	dist_scale = smoothstep(0.1, 0.3, dist_scale);
//
	for (float t = 0.0; t <= 8.0; t++) {
		float percent = (t + offset) / 8.0;
		float weight = 1.0 * (percent - percent * percent);
		float p = percent * power * dist_scale;
		vec4 sample = texture(SCREEN_TEXTURE, SCREEN_UV + velocity * p);
		color += sample * weight;
		total += weight;
	}
	
	COLOR = color / total;
//	COLOR.rg = velocity * 2.0 + 1.0;
}