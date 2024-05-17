extends GroundState

class_name GroundGunState

func shot() -> void:
	set_next_state(pp.shot_state)


func state_input(event : InputEvent) -> void: # 读入状态事件
	super(event)
	
	if event.is_action_pressed(pp.shot_action):
		shot()

