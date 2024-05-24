extends GroundState


func shot() -> void:
	set_next_state(pp.shot_state)


func state_input(event : InputEvent) -> void: # 读入状态事件
	super(event)
	
	if event.is_action_pressed(pp.shot_action):
		shot()
	
	if event.is_action_pressed(pp.special_1_action):
		character.is_gun = !character.is_gun
		if character.is_gun:
			set_next_state(character.pp.gun_start_state)
		else:
			set_next_state(character.ground_state())
			playback.travel(character.ground_animation())
	
	## 补子弹
	if event.is_action_pressed(pp.special_2_action) and character.angry >= 50:
		character.bullets_number = 50 - character.bullets_number
		character.angry -= 50
