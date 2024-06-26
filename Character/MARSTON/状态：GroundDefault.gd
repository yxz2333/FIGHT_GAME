extends GroundState


func attack() -> void:
	set_next_state(pp.attack_state)


func state_input(event : InputEvent) -> void:
	super(event)
	
	## 攻击
	if event.is_action_pressed(pp.attack_action):
		attack()
	
	## 切枪
	if event.is_action_pressed(pp.special_1_action):
		character.is_gun = !character.is_gun
		if character.is_gun:
			pp.feet_label.set_short_text("GUN")
			set_next_state(character.pp.gun_start_state)
		else:
			pp.feet_label.set_short_text("FIST")
			set_next_state(character.ground_state())
			playback.travel(character.ground_animation())
	
	## 补子弹
	if event.is_action_pressed(pp.special_2_action) and character.angry >= 50:
		pp.feet_label.set_short_text("RECOVER")
		character.bullets_number = 50
		character.angry -= 50
