shader_type canvas_item;

float rounded_rect(vec2 pos, vec2 size, float rad) { return length(max(abs(pos)-size+rad,0.0))-rad; }

void fragment() {
//	float dx = abs(UV.x - .5);
//	float dy = abs(UV.y - .5);
//	float d = 1.0 - (dx + dy) / 2.0;
	float d = rounded_rect(UV - .5, vec2(.5), 1.5);
	d = smoothstep(0.0, 1.0, d);
	COLOR.rgb = mix(vec3(1.0,0.0,0.0), vec3(0.0,1.0,0.5), d);// vec3(d);
}