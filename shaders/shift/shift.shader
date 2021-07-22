shader_type canvas_item;

uniform sampler2D tex1;
uniform sampler2D tex2;
uniform float time : hint_range(0.0, 1.0) = 0.0;

vec3 normal_dir(sampler2D tex, vec2 uv, vec2 pixel) {
//	float displace = 2.0;
//	float t = texture(tex, uv + vec2(0,-pixel.y)).r * displace;
//	float l = texture(tex, uv + vec2(-pixel.x,0)).r * displace;
//	float r = texture(tex, uv + vec2(pixel.x,0)).r * displace;
//	float b = texture(tex, uv + vec2(0,pixel.y)).r * displace;
//	vec3 n;
//	n.z = -(t - b);
//	n.x = (l - r);
//	n.y = 2.0 * pixel.y;
//	return normalize(n);

	// * terrainSize; //
	float h_c = texture(tex, uv).r;						// Height center.
	float h_r = texture(tex, uv + vec2(pixel.x, 0)).r;	// Height right.
	float h_u = texture(tex, uv + vec2(0, pixel.y)).r;	// Height up.
	float d_r = h_r - h_c;								// Delta up.
	float d_u = h_u - h_c;								// Delta right.
	
	float norm_power = 16.0;
	vec3 norm = cross(
		vec3(1, 0, d_r * norm_power),
		vec3(0, 1, d_u * norm_power));
	norm = normalize(norm) * .5 + .5;
	return norm;
}
void fragment() {
	COLOR.rgb = normal_dir(TEXTURE, UV, TEXTURE_PIXEL_SIZE);
//	float grad = texture(gradient, UV).r;
//	if (grad < time) {
//		COLOR = texture(TEXTURE, UV + vec2(0, time));
//	} else {
//		COLOR = texture(tex2, UV + vec2(0, time));
//	}
}