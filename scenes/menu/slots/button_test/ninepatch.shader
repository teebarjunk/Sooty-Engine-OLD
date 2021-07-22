shader_type canvas_item;

uniform vec2 scale;

uniform int right;
uniform int top;
uniform int left;
uniform int bottom;

float map(float value, float originalMin, float originalMax, float newMin, float newMax) {
    return (value - originalMin) / (originalMax - originalMin) * (newMax - newMin) + newMin;
} 

float process_axis(float coord, float pixel, float texture_pixel, float start, float end) {
	if (coord > 1.0 - end * pixel) {
		return map(coord, 1.0 - end * pixel, 1.0, 1.0 - texture_pixel * end, 1.0);
	} else if (coord > start * pixel) {
		return map(coord, start * pixel, 1.0 - end * pixel, start * texture_pixel, 1.0 - end * texture_pixel);
	} else {
		return map(coord, 0.0, start * pixel, 0.0, start * texture_pixel);
	}
}

void fragment() {
	vec2 pixel_size = TEXTURE_PIXEL_SIZE / scale;
	vec2 mappedUV = vec2(
		process_axis(UV.x, pixel_size.x, TEXTURE_PIXEL_SIZE.x, float(left), float(right)),
		process_axis(UV.y, pixel_size.y, TEXTURE_PIXEL_SIZE.y, float(top), float(bottom))
	);
	COLOR = texture(TEXTURE, mappedUV);
}