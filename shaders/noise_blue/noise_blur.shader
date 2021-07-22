shader_type canvas_item;

void fragment() {
	vec3 rgb = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
//	vec2 bn_res = iChannelResolution[0].xy;
	vec4 bn = texture(SCREEN_TEXTURE, mod(SCREEN_PIXEL_SIZE, SCREEN_UV) / SCREEN_PIXEL_SIZE);
	bn = pow(bn, vec4(0.45)); // gamma
	COLOR = vec4(step(bn.rgb, rgb), 1.0);
}

//void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
//    vec3 img = texture(iChannel1, fragCoord/iResolution.xy).xyz;
//    vec2 bn_res = iChannelResolution[0].xy;
//    vec4 bn = texture( iChannel0, mod(fragCoord, bn_res) / bn_res);
//    bn = pow(bn, vec4(0.45)); // gamma
//    fragColor = vec4(step(bn.xyz, img),1.0);
//}