shader_type canvas_item;
render_mode blend_mix;

uniform vec2 pos;

uniform float boundary : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	vec2 uv = SCREEN_UV;
	if (uv.y >= boundary) {
    	COLOR.a = 0.0;// = texture(SCREEN_TEXTURE, vec2(uv.x, uv.y));
	}
	else {
		float y = (boundary - uv.y) / boundary;
		float xoffset = 0.002 * (1.0 - y) * cos(TIME * 2.0 + 100.0 * uv.y);
		float yoffset = y * 0.01 * cos(TIME* 3.0 + 50.0 * uv.y);
		vec4 color = textureLod(SCREEN_TEXTURE, vec2(uv.x + xoffset, (boundary * 2.0 - uv.y + yoffset)), y);
		COLOR = color;
//		COLOR.a = pow(y, 0.5);
	}
}