shader_type canvas_item;

uniform float blur : hint_range(0.0, 8.0) = 0.5;
uniform float high : hint_range(0.0, 1.0) = 0.5;
uniform float rot : hint_range(-3.141, 3.141) = 0.0;
uniform float size : hint_range(0.0, 1.0) = 0.5;
uniform float fade : hint_range(0.0, 0.1) = 0.01;

vec2 rotate_uv(vec2 uv, float r) {
	float c = cos(r);
	float s = sin(r);
	uv -= .5;
	return vec2(c * uv.x + s * uv.y, c * uv.y - s * uv.x) + .5;
}

void fragment() {
	float d = abs(rotate_uv(UV, rot).y - high);
	d = smoothstep(size - fade, size + fade, d);
	
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, d * blur);
//	COLOR.r = mix(COLOR.r, texture(SCREEN_TEXTURE, SCREEN_UV + vec2(d * 2.0 * SCREEN_PIXEL_SIZE.x, 0.0)).r, d);
//	COLOR.b = mix(COLOR.b, texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-d * 2.0 * SCREEN_PIXEL_SIZE.x, 0.0)).b, d);
}