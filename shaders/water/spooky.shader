shader_type canvas_item;
render_mode blend_sub;

uniform vec2 pos;

void fragment() {
	vec2 noise1 = texture(TEXTURE, UV * 2.0 + vec2(TIME * .01, TIME * .02)).rg;
	vec2 noise2 = texture(TEXTURE, UV * 1.3 + vec2(TIME * .02, TIME * .01)).rg;
	vec2 color = mix(noise1, noise2, .5) * 2.0 - 1.0;
	color *= SCREEN_PIXEL_SIZE * 32.0;
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV + color);
	COLOR = screen;
	COLOR.r = UV.y;
}