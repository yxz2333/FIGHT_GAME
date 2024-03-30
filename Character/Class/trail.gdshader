shader_type canvas_item;

uniform vec4 tint_color: source_color = vec4(1.0);

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	float grey = (col.r + col.g + col.b) / 3.0; // 灰色
	grey = smoothstep(0.3, 0.6, grey) * 0.4 + 0.6;
	COLOR = vec4(grey * tint_color.rgb, col.a);
}
