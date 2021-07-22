shader_type canvas_item;
//render_mode blend_sub;

uniform float scale : hint_range(-0.1, 0.1) = 0.05;
uniform float power : hint_range(0.5, 4.0) = 2.0;

void fragment() {
	float dist = pow(length(UV - .5), power);
	dist *= scale;
	vec4 screen_r = texture(SCREEN_TEXTURE, SCREEN_UV - dist);
	vec4 screen_g = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 screen_b = texture(SCREEN_TEXTURE, SCREEN_UV + dist);
	COLOR.rgb = vec3(screen_r.r, screen_g.g, screen_b.b);
}