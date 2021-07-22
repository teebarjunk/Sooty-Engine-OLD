shader_type canvas_item;

uniform vec2 scale = vec2(1.0);
uniform float strength : hint_range(0.0, 40.0) = 1.0;
uniform float lum_strength : hint_range(0.0, 1.0) = 0.5;

float gray(vec3 clr) { return 0.21 * clr.r + 0.72 * clr.g + 0.07 * clr.b; }
float rand(vec2 co) { return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453); }

void fragment() {
	// noise.
	vec2 uv = UV / SCREEN_PIXEL_SIZE;
	uv = round(uv / scale) * scale;
//	uv *= TIME * SCREEN_PIXEL_SIZE;
	
	vec2 offset = (vec2(rand(uv), rand(uv * 10.0)) * 2.0 - 1.0) * SCREEN_PIXEL_SIZE * strength;
//	float noise = rand(uv);
	
	COLOR *= texture(SCREEN_TEXTURE, SCREEN_UV + offset);
	// make lighter areas noisier?
//	float gray = mix(1.0, pow(gray(COLOR.rgb), 2.0) * 2.0, lum_strength);
//	COLOR.rgb += vec3(noise) * gray * strength;
}