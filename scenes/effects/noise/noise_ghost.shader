shader_type canvas_item;
render_mode blend_add;

const float PHI = 1.61803398874989484820459; // Φ = Golden Ratio 

uniform float size : hint_range(1.0, 4.0) = 1.0;

float gold_noise(vec2 xy, float seed) {
	return fract(tan(distance(xy*PHI, xy)*seed)*xy.x);
}

vec3 gold_noise3(vec2 xy, float seed) {
	return vec3(gold_noise(xy, fract(seed)+1.0), gold_noise(xy, fract(seed)+2.0), gold_noise(xy, fract(seed)+3.0));
}

float luminosity(vec3 clr) {
	return 0.21 * clr.r + 0.72 * clr.g + 0.07 * clr.b;
}

float rand(vec2 uv, float seed) {
	float f = abs(seed) + 1.0;
	float x = dot(uv, vec2(12.9898,78.233) * f);
	return fract(sin(x) * 43758.5453);
}

vec3 rand3(vec2 uv, float seed) {
	return vec3(rand(uv, seed), rand(uv, seed + 123.32134), rand(uv, seed + 5435.3453));
}

void fragment() {
	vec2 c = floor(size) * SCREEN_PIXEL_SIZE;
	vec2 uv = floor(SCREEN_UV / c) * c;
	vec4 screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, 3.0);
	float seed = round(TIME * 5.0) / 5.0;
	vec3 noise = gold_noise3(uv / SCREEN_PIXEL_SIZE, seed);
	float gray = luminosity(screen.rgb);
	gray = pow(1.0 - gray, 2.0);
	COLOR.rgb = screen.rgb * noise;
	COLOR.a = gray;
}