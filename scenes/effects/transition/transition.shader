shader_type canvas_item;
render_mode blend_premul_alpha;

uniform float time : hint_range(0.0, 1.0) = 0.0;
uniform float time_fade : hint_range(0.0, 1.0) = 0.1;
uniform sampler2D gradient : hint_white; 
uniform bool reverse = false;

float remap(float t, float in_min, float in_max, float out_min, float out_max) {
	return (t - in_min) / (in_max - in_min) * (out_max - out_min) + out_min;
}

void fragment() {
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 next_screen = texture(TEXTURE, vec2(UV.x, 1.0 - UV.y));
	float g = texture(gradient, UV).r;
	g = remap(g, -time_fade * 2.0, 1.0 + time_fade * 2.0, 0.0, 1.0);
	
	if (reverse) {
		float t = 1.0 - time;
		g = smoothstep(t - time_fade, t + time_fade, g);
		COLOR = mix(next_screen, screen, g);
	} else {
		g = smoothstep(time - time_fade, time + time_fade, g);
		COLOR = mix(screen, next_screen, g);
	}
}