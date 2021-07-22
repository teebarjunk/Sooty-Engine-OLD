shader_type canvas_item;

uniform float radius;
uniform float angle;
uniform vec2 center;

void fragment() {
	vec2 coord = SCREEN_UV;
	coord -= center;
	
	float d = length(coord);
	if (d < radius) {
		float percent = (radius - d) / radius;
		float theta = percent * percent * angle;
		float s = sin(theta);
		float c = cos(theta);
		coord = vec2(
			coord.x * c - coord.y * s,
			coord.x * s + coord.y * c
		);
	}
	coord += center;
	
	COLOR = texture(SCREEN_TEXTURE, coord);
//	vec2 clampedCoord = clamp(coord, vec2(0.0), vec2(1.0));
//	if (coord != clampedCoord) {
//		/* fade to transparent if we are outside the image */
//		COLOR.a *= max(0.0, 1.0 - length(coord - clampedCoord));
//	}
}