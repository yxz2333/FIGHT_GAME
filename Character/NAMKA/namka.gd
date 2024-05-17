extends Player



## 动态更改属性
@export var shot_freeze_timer : Timer  # 子弹冷却timer
var is_gun : bool = true               # 是否持枪



func check_when_decrease_speed() -> bool:
	if state_machine.current_state is GunStartState or state_machine.current_state is ShotState or (state_machine.current_state is AttackState and playback.get_current_node() == pp.attack_1_animation):
		return true
	return false


func update_animation_parameters() -> void: # 设置移动动画对应参数
	animation_tree.set("parameters/移动/blend_position", direction.x)
	animation_tree.set("parameters/持枪移动/blend_position", direction.x)
	
	
	var check : float = 1.0 if sprite.flip_h == false else -1.0       # 通过动画1D的更改，调整素材错位问题
	animation_tree.set("parameters/攻击_准备/blend_position", check)   # 调整素材错位问题
	animation_tree.set("parameters/攻击/blend_position", check)       # 调整素材错位问题


func ground_state() -> GroundState:
	return pp.ground_default_state if not is_gun else pp.ground_gun_state
	
func ground_animation() -> String:
	return pp.move_animation if not is_gun else pp.ground_gun_animation
