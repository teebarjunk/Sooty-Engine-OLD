shader_type canvas_item;
render_mode blend_mix;

uniform float h;
uniform float v;

void fragment() {
	vec2 ps = SCREEN_PIXEL_SIZE;
	vec4 col = vec4(0);
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-30.0, v*-30.0)) * 0.001479;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-29.0, v*-29.0)) * 0.001815;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-28.0, v*-28.0)) * 0.002212;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-27.0, v*-27.0)) * 0.002678;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-26.0, v*-26.0)) * 0.003218;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-25.0, v*-25.0)) * 0.003841;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-24.0, v*-24.0)) * 0.004553;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-23.0, v*-23.0)) * 0.00536;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-22.0, v*-22.0)) * 0.006266;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-21.0, v*-21.0)) * 0.007274;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-20.0, v*-20.0)) * 0.008387;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-19.0, v*-19.0)) * 0.009602;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-18.0, v*-18.0)) * 0.010917;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-17.0, v*-17.0)) * 0.012327;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-16.0, v*-16.0)) * 0.013823;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-15.0, v*-15.0)) * 0.015393;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-14.0, v*-14.0)) * 0.017023;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-13.0, v*-13.0)) * 0.018695;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-12.0, v*-12.0)) * 0.020389;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-11.0, v*-11.0)) * 0.022083;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-10.0, v*-10.0)) * 0.023753;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-9.0, v*-9.0)) * 0.025372;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-8.0, v*-8.0)) * 0.026913;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-7.0, v*-7.0)) * 0.028351;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-6.0, v*-6.0)) * 0.02966;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-5.0, v*-5.0)) * 0.030814;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-4.0, v*-4.0)) * 0.031791;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-3.0, v*-3.0)) * 0.032573;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-2.0, v*-2.0)) * 0.033143;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*-1.0, v*-1.0)) * 0.03349;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*0.0, v*0.0)) * 0.033606;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*1.0, v*1.0)) * 0.03349;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*2.0, v*2.0)) * 0.033143;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*3.0, v*3.0)) * 0.032573;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*4.0, v*4.0)) * 0.031791;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*5.0, v*5.0)) * 0.030814;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*6.0, v*6.0)) * 0.02966;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*7.0, v*7.0)) * 0.028351;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*8.0, v*8.0)) * 0.026913;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*9.0, v*9.0)) * 0.025372;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*10.0, v*10.0)) * 0.023753;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*11.0, v*11.0)) * 0.022083;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*12.0, v*12.0)) * 0.020389;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*13.0, v*13.0)) * 0.018695;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*14.0, v*14.0)) * 0.017023;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*15.0, v*15.0)) * 0.015393;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*16.0, v*16.0)) * 0.013823;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*17.0, v*17.0)) * 0.012327;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*18.0, v*18.0)) * 0.010917;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*19.0, v*19.0)) * 0.009602;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*20.0, v*20.0)) * 0.008387;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*21.0, v*21.0)) * 0.007274;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*22.0, v*22.0)) * 0.006266;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*23.0, v*23.0)) * 0.00536;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*24.0, v*24.0)) * 0.004553;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*25.0, v*25.0)) * 0.003841;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*26.0, v*26.0)) * 0.003218;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*27.0, v*27.0)) * 0.002678;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*28.0, v*28.0)) * 0.002212;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*29.0, v*29.0)) * 0.001815;
	col += texture(SCREEN_TEXTURE, SCREEN_UV + ps * vec2(h*30.0, v*30.0)) * 0.001479;
	col.a = 1.0;
	COLOR = col;
}