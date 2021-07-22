shader_type canvas_item;

uniform float Radius;
uniform vec2 Size;
 
const float GoldenAngle = 2.39996323;
 
// bigger is better quality
const float Iterations = 8.0;
 
const mat2 Rotation = mat2(
	vec2(cos(GoldenAngle),
	sin(GoldenAngle)),
	vec2(-sin(GoldenAngle),
	cos(GoldenAngle))
);
 
const float ContrastAmount = 150.0;
const vec3 ContrastFactor = vec3(9.0);
const float Smooth = 2.0;
 
///////////
/*
    calculates circle of confusion diameter for each fixel from physical parameters and depth map
 
    this function is unused
 
    see http://ivizlab.sfu.ca/papers/cgf2012.pdf, page 10
*/
//float blurRadius(
//	float A, // aperture
//	float f, // focal length
//	float S1, // focal distance
//	float far, // far clipping plane
//	float maxCoc, // mac coc diameter
//	vec2 uv,
//	sampler2D depthMap)
//{
//	vec4 currentPixel = texture(depthMap, uv);
//	float S2 = currentPixel.r * far;
//	//https://en.wikipedia.org/wiki/Circle_of_confusion
//	float coc = A * (abs(S2 - S1) / S2 ) * ( f / (S1 - f) );
//	float sensorHeight = 0.024; // 24mm
//	float percentOfSensor = coc / sensorHeight;
//	// blur factor
//	return clamp(percentOfSensor, 0.0f, maxCoc);
//}

vec3 bokeh(sampler2D tex, vec2 uv, float radius) {
	vec3 num, weight;
	float rec = 1.0; // reciprocal 
	vec2 horizontalAngle = vec2(0.0, radius * 0.01 / sqrt(Iterations));
	for (float i; i < Iterations; i++) {
		rec += 1.0 / rec;
		horizontalAngle = horizontalAngle * Rotation;
		vec2 offset = (rec - 1.0) * horizontalAngle;
		vec2 aspect = vec2(Size.y / Size.x, 1.0);
		vec2 sampleUV = uv + aspect * offset;
		vec3 col = texture(tex, sampleUV).rgb;
		// increase contrast and smooth
		vec3 bokeh = Smooth + pow(col, ContrastFactor) * ContrastAmount;
		num += col * bokeh;
		weight += bokeh;
	}
	return num / weight;
}
 
void fragment() {
    COLOR.rgb = bokeh(SCREEN_TEXTURE, SCREEN_UV, Radius);
    COLOR.a = 1.0;
}