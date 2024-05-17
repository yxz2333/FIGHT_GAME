extends GroundState

class_name GroundDefaultState

func attack() -> void:
	set_next_state(pp.attack_state)


func state_input(event : InputEvent) -> void: # 读入状态事件
	super(event)
	
	if event.is_action_pressed(pp.attack_action):
		attack()
