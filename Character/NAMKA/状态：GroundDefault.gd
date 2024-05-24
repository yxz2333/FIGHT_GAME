extends GroundState


func attack() -> void:
	set_next_state(pp.attack_state)


func state_input(event : InputEvent) -> void:
	super(event)
	
	if event.is_action_pressed(pp.attack_action):
		attack()
		
	if event.is_action_pressed(pp.special_1_action):
		character.is_gun = !character.is_gun
		if character.is_gun:
			pp.feet_label.set_short_text("GUN")
			set_next_state(character.pp.gun_start_state)
		else:
			pp.feet_label.set_short_text("SWORD")
			set_next_state(character.ground_state())
			playback.travel(character.ground_animation())
