extends Player



## 动态更改属性
var bullets_number : int    # 子弹数
var is_gun : bool = false   # 是否持枪



func update_animation_parameters() -> void: # 设置移动动画对应参数
	animation_tree.set("parameters/移动/blend_position", direction.x)
	animation_tree.set("parameters/持枪移动/blend_position", direction.x)


func ground_state() -> GroundState:
	return pp.ground_default_state if not is_gun else pp.ground_gun_state
	
func ground_animation() -> String:
	return pp.move_animation if not is_gun else pp.ground_gun_animation
