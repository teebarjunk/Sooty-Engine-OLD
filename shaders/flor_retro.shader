shader_type canvas_item;

uniform float scaler : hint_range(0, 64) = 1.0;
uniform float color_count : hint_range(1, 64) = 4.0;

uniform float lod : hint_range(0, 4) = 1.0;
uniform float scale_s : hint_range(.125, 4.0) = 1.0;
uniform float scale_v : hint_range(.125, 4.0) = 1.0;

uniform vec4 chroma : hint_color = vec4(0.05, 0.63, 0.14, 1); // Color to be removed.

vec3 lerp(vec3 colorone, vec3 colortwo, float value) {
	return (colorone + value*(colortwo-colorone));
}

const mat4 rgb_to_yuv = mat4(	vec4(0.257,  0.439, -0.148, 0.0),
								vec4(0.504, -0.368, -0.291, 0.0),
								vec4(0.098, -0.071,  0.439, 0.0),
								vec4(0.0625, 0.500,  0.500, 1.0));

uniform vec2 mask_range = vec2(0.005, 0.26);

//compute color distance in the UV (CbCr, PbPr) plane
float colorclose(vec3 yuv, vec3 keyYuv, vec2 tol)
{
	float tmp = sqrt(pow(keyYuv.g - yuv.g, 2.0) + pow(keyYuv.b - yuv.b, 2.0));
	if (tmp < tol.x)
		return 0.0;
	else if (tmp < tol.y)
		return (tmp - tol.x)/(tol.y - tol.x);
	else
		return 1.0;
}

vec3 rgb_to_hsv(vec3 RGB) {
	vec4 k = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
	vec4 p = RGB.g < RGB.b ? vec4(RGB.b, RGB.g, k.w, k.z) : vec4(RGB.gb, k.xy);
	vec4 q = RGB.r < p.x   ? vec4(p.x, p.y, p.w, RGB.r) : vec4(RGB.r, p.yzx);
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv_to_rgb(vec3 HSV) {
	vec4 k = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(HSV.xxx + k.xyz) * 6.0 - k.www);
	return HSV.z * lerp(k.xxx, clamp(p - k.xxx, 0.0, 1.0), HSV.y);
}

void fragment() {
	vec2 uv = UV;
	vec2 scl = vec2(scaler) * TEXTURE_PIXEL_SIZE;
	uv = round(uv / scl) * scl;
	
	vec4 color = textureLod(TEXTURE, uv, lod);
	
	// chroma
	vec4 key_yuv = rgb_to_yuv * chroma;
    vec4 yuv = rgb_to_yuv * color;
	
	float mask = 1.0 - colorclose(yuv.rgb, key_yuv.rgb, mask_range);
    color = max(color - mask * chroma, 0.0);// + texColor1 * mask;
	
	// color reduce
	float cut_color = 1. / color_count;
	color.rgb = rgb_to_hsv(color.rgb);
//	color.x *= scale_h;
	color.y *= scale_s;
	color.z *= scale_v;
	vec2 target_c = cut_color * floor(color.gb / cut_color);
	color.rgb = hsv_to_rgb(vec3(color.r, target_c));
	
	COLOR = color;
}