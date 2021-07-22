shader_type canvas_item;

void fragment() {
	COLOR.rgb = vec3(1.0) - texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
}