shader_type canvas_item;

//uniform sampler2D texture1;
//uniform vec2 delta0;
//uniform vec2 delta1;
uniform float radius : hint_range(0.0, 1.0) = 0.5;
//varying vec2 texCoord;

//float random(vec3 scale, vec3 seed) {
//	/* use the fragment position for a different seed per-pixel */
//	return fract(sin(dot(/*gl_FragCoord.xyz + */seed, scale)) * 43758.5453);// + seed);
//}
//
//vec4 sample(sampler2D tex, vec2 uv, vec2 delta) {
//	/* randomize the lookup values to hide the fixed number of samples */
//	float offset = random(vec3(delta, 151.7182), vec3(0.0));
//	vec4 color = vec4(0.0);
//	float total = 0.0;
//	for (float t = 0.0; t <= 30.0; t++) {
//		float percent = (t + offset) / 30.0;
//		color += texture(tex, uv + delta * percent);
//		total += 1.0;
//	}
//	return color / total;
//}

void fragment() {
	vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);
	float weight = 0.0;
	float r = radius * 4.0;
	for(float x = -r; x < r; x++) {
		for(float y = -r; y < r; y++) {
			vec2 coord = vec2(x, y);// * 8.0;  
			if (length(coord) < r) {
				vec4 texel = textureLod(TEXTURE, UV + coord * TEXTURE_PIXEL_SIZE * 8.0, 1.0 + radius * 4.0);
				float w = pow(length(texel.rgb), 2.0);
				weight += w;
				finalColor += texel * w;
			}
		}
	}
	COLOR = finalColor / weight;
}