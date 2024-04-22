shader_type canvas_item;

uniform float cutoff : hint_range(0.0, 1.0, 0.1);       // 过渡效果起始点 
uniform float smooth_size : hint_range(0.0, 1.0, 0.1);  // 过渡区域的平滑度
uniform sampler2D mask;                                 // 黑白遮罩纹理

void fragment(){  // 对每个像素
	float value = texture(mask, UV).r; // 这里用rgb都一样，因为是黑白遮罩
	
	// 以下代码最好找机会好好理解
	float alpha = smoothstep(cutoff, cutoff + smooth_size, value * (1.0 - smooth_size) + smooth_size);
	COLOR = vec4(COLOR.rgb, alpha);
}