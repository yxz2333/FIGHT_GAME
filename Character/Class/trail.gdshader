shader_type canvas_item;      // 指定着色器类型为CanvasItem，用于2D渲染。

uniform vec4 tint_color: source_color = vec4(1.0); // 可外部更改的颜色变量

varying vec4 modulate_color;  // varying关键字用于在vertex和fragment函数之间传递数据。

void vertex() {
	// COLOR是内置变量，代表当前顶点的颜色。
	// 这里将它赋值给modulate_color，以便在fragment函数中使用。
	modulate_color = COLOR;
}

void fragment() {
	vec4 col = texture(TEXTURE, UV) * modulate_color;
	
	// 计算灰度值，将颜色的RGB值相加后除以3。
	float grey = (col.r + col.g + col.b) / 3.0; 
	
	// 使用smoothstep函数平滑过渡灰度值。
	grey = smoothstep(0.3, 0.6, grey) * 0.4 + 0.6;
	
	// 最终颜色由调整后的灰度值和tint_color的RGB值相乘，保持原有的alpha值。
	COLOR = vec4(grey * tint_color.rgb, col.a);
}
