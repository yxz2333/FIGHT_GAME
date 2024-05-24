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
			set_next_state(pp.gun_start_state)
		else:
			character.is_gun = false
	
	## 空中射击
	if character.ground_state() == pp.ground_gun_state and event.is_action_pressed(pp.shot_action):
		set_next_state(pp.shot_state)
	
	## 空中补子弹
	if event.is_action_pressed(pp.special_2_action) and character.angry >= 50:
		character.bullets_number = 50 - character.bullets_number
		character.angry -= 50
