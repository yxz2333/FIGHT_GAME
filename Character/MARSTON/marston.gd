extends Player

func update_animation_parameters() -> void: # 设置移动动画对应参数
	animation_tree.set("parameters/移动/blend_position", direction.x)
