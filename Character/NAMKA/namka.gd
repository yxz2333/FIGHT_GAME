extends Player



func update_animation_parameters() -> void: # 设置移动动画对应参数
	animation_tree.set("parameters/移动/blend_position", direction.x)
	animation_tree.set("parameters/持枪移动/blend_position", direction.x)
	
	
	var check : float = 1.0 if sprite.flip_h == false else -1.0       # 通过动画1D的更改，调整素材错位问题
	animation_tree.set("parameters/攻击_准备/blend_position", check)   # 调整素材错位问题
	animation_tree.set("parameters/攻击/blend_position", check)       # 调整素材错位问题
