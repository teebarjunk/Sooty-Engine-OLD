shader_type canvas_item;
render_mode blend_premul_alpha;

uniform float size : hint_range(0.0, 3.0) = 1.0;
uniform float size_ratio : hint_range(0.0, 1.0) = 0.0;
uniform float rotation : hint_range(-3.14, 3.14) = 0.0;

uniform float open : hint_range(0.0, 1.0) = 0.5;
uniform float open_smoothing : hint_range(0.0, 1.0) = 0.5;

uniform vec2 rect;

vec2 rotate_uv(vec2 uv) {
	float c = cos(rotation);
	float s = sin(rotation);
	return vec2(c * uv.x + s * uv.y, c * uv.y - s * uv.x);
}

void fragment() {
	vec2 uv = UV;
	uv -= .5;
	uv.x *= mix(rect.x / rect.y, 1.0, size_ratio);
	uv /= size;
	uv = rotate_uv(uv);
	uv += .5;
	
	float grad = texture(TEXTURE, uv).r;
	grad = 1.0 - smoothstep(open, open + open_smoothing, grad);
	
	COLOR = vec4(grad);
}