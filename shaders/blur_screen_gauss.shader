shader_type canvas_item;

const float PI2 = 6.28318530718;
const float directions = 16.0; // 16.0: Higher = +quality -speed.
const float quality = 3.0; // 3.0: Higher = +quality -speed.
uniform float spreadx : hint_range(1.0, 32.0) = 16.0;
uniform float spready : hint_range(1.0, 32.0) = 16.0;

void fragment() {
	vec2 offset = vec2(spreadx, spready) * SCREEN_PIXEL_SIZE;
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	for( float d=0.0; d<PI2; d+=PI2/directions) {
		for(float i=1.0/quality; i<=1.0; i+=1.0/quality) {
			color += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(cos(d), sin(d)) * offset * i);
		}
	}
	
	color /= quality * directions;// - 15.0;
	COLOR =  color;
}