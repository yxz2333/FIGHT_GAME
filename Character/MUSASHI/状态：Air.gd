extends AirState


func state_input(event : InputEvent) -> void:  # 读取输入
	super(event)
	## 空中普攻
	if character.ground_state() == pp.ground_default_state and event.is_action_pressed(pp.attack_action):
		set_next_state(pp.charge_state)
		
	if event.is_action_pressed(pp.special_1_action) and character.angry >= 20:
		character.angry -= 20
		set_next_state(pp.defense_state)
