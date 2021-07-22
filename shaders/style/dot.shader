shader_type canvas_item;

uniform float angle : hint_range(0.0, 3.141);
uniform float scale = 1;
uniform int stepper : hint_range(1, 16) = 16;

float gray(vec3 clr) { return 0.21 * clr.r + 0.72 * clr.g + 0.07 * clr.b; }

float pattern(vec2 uv) {
	float s = sin(angle);
	float c = cos(angle);
	vec2 point = vec2(
	    c * uv.x - s * uv.y,
	    s * uv.x + c * uv.y
	) / scale;
	return (sin(point.x) * sin(point.y)) * 4.0;
}

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	// average
//	float avg = (color.r + color.g + color.b) / 3.0;
	// luminance
	float gray = gray(color.rgb);
	gray = round(gray * float(stepper)) / float(stepper);
	float dots = gray * 10.0 - 5.0 + pattern(SCREEN_UV / SCREEN_PIXEL_SIZE);
	COLOR.rgb = vec3(dots);
}