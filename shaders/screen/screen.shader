shader_type canvas_item;

uniform float gamma = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;
uniform float brightness = 1.0;
uniform float red = 1.0;
uniform float green = 1.0;
uniform float blue = 1.0;

void fragment() {
	vec4 c = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec3 rgb = pow(c.rgb, vec3(1.0 / gamma));
	rgb = mix(vec3(.5), mix(vec3(dot(vec3(.2125, .7154, .0721), rgb)), rgb, saturation), contrast);
	rgb.r *= red;
	rgb.g *= green;
	rgb.b *= blue;
	c.rgb = rgb * brightness;
	COLOR = c;
}