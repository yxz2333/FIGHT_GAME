// 指定着色器类型为canvas_item，适用于2D渲染
shader_type canvas_item;

uniform vec4 outlineColor: source_color = vec4(1.0, 0.0, 0.0, 1.0); // 定义轮廓的颜色和透明度（完全不透明）
uniform float outlineWidth = 0.02; // 定义轮廓的宽度

// fragment()函数处理每个像素的渲染
void fragment() { 
    float alpha = texture(TEXTURE, UV).a;  // 获取当前像素的alpha值（透明度）
    float maxAlpha = 0.0;  // 初始化最大alpha值变量，用于确定周围像素的最大透明度
	
    // 遍历当前像素周围的像素
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * outlineWidth;  // 计算周围像素的偏移量
            maxAlpha = max(maxAlpha, texture(TEXTURE, UV + offset).a);  // 获取周围像素的alpha值，并更新最大alpha值
        }
    }

    
    if(maxAlpha > alpha)       // 如果周围像素的最大alpha值大于当前像素的alpha值
        COLOR = outlineColor;  // 将当前像素的颜色设置为轮廓颜色
    else                       // 否则，保持当前像素的原始颜色和透明度 
        COLOR = texture(TEXTURE, UV);
}
