extends Player


var check : float = 1.0 # 通过动画1D的更改，调整素材错位问题
func update_animation_parameters() -> void: # 设置移动动画对应参数
	animation_tree.set("parameters/移动/blend_position", direction.x)
	animation_tree.set("parameters/攻击_准备/blend_position", check) # 调整素材错位问题
	animation_tree.set("parameters/攻击/blend_position", check) # 调整素材错位问题
	animation_tree.set("parameters/持枪移动/blend_position", direction.x)

func update_facing_directon() -> void: # 更新面朝方向
	if not state_machine.check_if_can_overturn(): # 检查是否能转向
		return

	if direction.x > 0: # 朝右
		check = 1.0
		sprite.flip_h = false
	elif direction.x < 0: # 朝左
		check = -1.0
		sprite.flip_h = true
		
	emit_signal("facing_direction_changed", !sprite.flip_h) # 发出信号，让剑的碰撞区域也反转
