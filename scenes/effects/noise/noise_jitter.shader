shader_type canvas_item;

float rand(vec2 uv, float seed) {
	float f = abs(seed) + 1.0;
	float x = dot(uv, vec2(12.9898,78.233) * f);
	return fract(sin(x) * 43758.5453);
}

void fragment() {
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 tex = texture(TEXTURE, UV + fract(rand(vec2(.0,.001), TIME) * 10.0));
	
	COLOR = screen - tex * .2;
}