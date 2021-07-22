shader_type canvas_item;

uniform sampler2D screen;

void fragment() {
	COLOR = texture(screen, UV);
	COLOR.a = .999;
}