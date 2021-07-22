shader_type canvas_item;

uniform float dist : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec2 uv = UV;
	uv -= .5;
	uv *= .6;
	uv += .5;
	
	float t = max(
		abs(0.5 - uv.x),
		abs(0.5 - uv.y)
	);
	t *= 2.0;
	t = 1.0 - abs(0.5 - t);
	
	t = smoothstep(0.9, 0.999, t);
	
	COLOR.rgba = vec4(t);
}