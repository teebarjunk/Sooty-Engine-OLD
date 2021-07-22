shader_type canvas_item;

uniform vec2 r = vec2(-1, 0);
uniform vec2 g = vec2(1, 0);
uniform vec2 b = vec2(0, 0);

void fragment() {
	COLOR.r = texture(SCREEN_TEXTURE, SCREEN_UV + r * SCREEN_PIXEL_SIZE).r;
	COLOR.g = texture(SCREEN_TEXTURE, SCREEN_UV + g * SCREEN_PIXEL_SIZE).g;
	COLOR.b = texture(SCREEN_TEXTURE, SCREEN_UV + b * SCREEN_PIXEL_SIZE).b;
	COLOR.a = texture(SCREEN_TEXTURE, SCREEN_UV).a;
}