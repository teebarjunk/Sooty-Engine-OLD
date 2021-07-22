shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 16.0) = 8.0;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 x = SCREEN_PIXEL_SIZE * pixel_size;
	uv = round(uv / x) * x;
	vec4 tex = texture(SCREEN_TEXTURE, uv);
	COLOR = tex;
}