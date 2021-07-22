shader_type canvas_item;

uniform float blur : hint_range(0.0, 16.0);

void fragment() {
	vec4 behind = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 tex = textureLod(TEXTURE, UV, blur) * COLOR;
	COLOR = mix(behind, tex, tex.a);
//	COLOR *= .85;
}