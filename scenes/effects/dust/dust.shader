shader_type canvas_item;
render_mode blend_mix;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR.rgb = vec3(1.0);
	COLOR.a = COLOR.r * color.a * .25 * COLOR.a;
}