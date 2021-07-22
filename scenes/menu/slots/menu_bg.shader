shader_type canvas_item;

uniform sampler2D tex1;
uniform sampler2D tex2;
uniform float time : hint_range(0, 1) = 0.0;
uniform float blur = 1.0;

void fragment() {
	COLOR = mix(textureLod(tex1, UV, blur), textureLod(tex2, UV, blur), time);
}