extends AirState


func state_input(event : InputEvent) -> void:  # 读取输入
	super(event)
	## 空中普攻
	if character.ground_state() == pp.ground_default_state and event.is_action_pressed(pp.attack_action):
		set_next_state(pp.attack_state)
	
	## 空中切枪
	if event.is_action_pressed(pp.special_1_action):
		if character.ground_state() != pp.ground_gun_state:
			character.is_gun = true
			pp.feet_label.set_short_text("GUN")
			set_next_state(pp.gun_start_state)
		else:
			pp.feet_label.set_short_text("SWORD")
			character.is_gun = false
	
	## 空中射击
	if character.ground_state() == pp.ground_gun_state and event.is_action_pressed(pp.shot_action):
		set_next_state(pp.shot_state)
