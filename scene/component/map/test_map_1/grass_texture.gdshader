shader_type canvas_item;
render_mode blend_premul_alpha;

uniform sampler2D overlay_tex: repeat_enable, filter_nearest;
uniform float scale = 0.006944444;
uniform float threshold = 0.995;
uniform float alpha_threshold = 0.5;
varying vec2 world_position;

void vertex(){
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// 计算混合系数
	float mix_amount = 0.0;
	
	// 只在像素不透明且是红色时混合
	if (COLOR.a > alpha_threshold && COLOR.r >= threshold) {
		mix_amount = 1.0;
	}
	
	// 采样叠加纹理
	vec4 overlay_color = texture(overlay_tex, world_position * scale);
	
	// 最终输出
	COLOR = mix(COLOR, overlay_color, mix_amount);
	
	// 处理完全透明的像素
	if (COLOR.a < 0.01) {
		discard;  // 或者直接设置为透明
		// COLOR.a = 0.0;  // 或者这个
	}
}