shader_type canvas_item;

uniform float angle;
uniform float scale;

float pattern(vec2 uv, float a) {
	float s = sin(a), c = cos(a);
	vec2 point = vec2(
		c * uv.x - s * uv.y,
		s * uv.x + c * uv.y
	) * scale;
	return (sin(point.x) * sin(point.y)) * 4.0;
}

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec3 cmy = 1.0 - color.rgb;
	float k = min(cmy.x, min(cmy.y, cmy.z));
	cmy = (cmy - k) / (1.0 - k);
	vec2 uv = SCREEN_UV / SCREEN_PIXEL_SIZE;
	cmy = clamp(cmy * 10.0 - 3.0 + vec3(pattern(uv, angle + 0.26179), pattern(uv, angle + 1.30899), pattern(uv, angle)), 0.0, 1.0);
	k = clamp(k * 10.0 - 5.0 + pattern(uv, angle + 0.78539), 0.0, 1.0);
	COLOR = vec4(1.0 - cmy - k, color.a);
}