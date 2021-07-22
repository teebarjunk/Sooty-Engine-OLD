shader_type canvas_item;

uniform float zoom = 1.0;
uniform vec2 skew = vec2(0, 0.0);

void fragment() {
	vec2 uv = UV;
	uv -= .5;
	uv /= zoom;//mix(1.0, 1.1, zoom);
	vec2 s = 1.0 - (uv * skew);
	uv /= (s.x * s.y);
	uv += .5;
	COLOR = texture(TEXTURE, uv);
	
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR.a = 0.0;
	
	} else {
		float gamma = mix(0.95, 1.05, zoom);
		float saturation = mix(0.8, 1.2, zoom);
		float contrast = mix(0.95, 1.05, zoom);
		
		vec4 color = texture(TEXTURE, uv);
		vec3 rgb = pow(color.rgb, vec3(1.0 / gamma));
		rgb = mix(vec3(.5), mix(vec3(dot(vec3(.2125, .7154, .0721), rgb)), rgb, saturation), contrast);
		
		float brightness = 1.0;// - skew.y * .5;
		COLOR.rgb = rgb * brightness;
		COLOR.a = color.a;
	}
}