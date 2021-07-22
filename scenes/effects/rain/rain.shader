shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec2 uv = SCREEN_UV;
	uv.x += color.r * SCREEN_PIXEL_SIZE.x * 1.0;
	uv.y -= color.r * SCREEN_PIXEL_SIZE.y * 2.0;
	vec4 screen = texture(SCREEN_TEXTURE, uv);
	screen.rgb += screen.rgb * 0.1 * color.a;
	COLOR = screen;
}