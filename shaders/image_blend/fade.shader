shader_type canvas_item;
render_mode blend_mix;

// fades from one sprite to the next

uniform sampler2D texture2 : hint_white;
uniform float blend : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 old_color = texture(TEXTURE, UV);
	vec4 new_color = texture(texture2, UV);
	COLOR = mix(old_color, new_color, blend);
}