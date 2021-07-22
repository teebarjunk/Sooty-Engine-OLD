shader_type canvas_item;

highp float rand(vec2 co, float seed) {
	
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot(co + seed, vec2(a, b)), sn = mod(dt, 3.14159);
	return fract(sin(sn) * c + seed);
}

vec2 s(vec2 uv, float v) {
	uv.x = round(uv.x * v) / v;
	uv.y = round(uv.y * v) / v;
	return uv;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 uvx = s(UV, 32.0) * 2.0 - 1.0;
	uv.x += rand(uvx, 1.23) * SCREEN_PIXEL_SIZE.x * 16.0;
	uv.y += rand(uvx, TIME*.0000001) * SCREEN_PIXEL_SIZE.y * 16.0;
//	uv.y += rand(uv, 2.3) * SCREEN_PIXEL_SIZE.y;
//	uv += uvx * SCREEN_PIXEL_SIZE;
	COLOR = texture(SCREEN_TEXTURE, uv);
}