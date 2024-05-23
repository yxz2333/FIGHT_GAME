extends GroundState


func state_input(event : InputEvent) -> void:
	super(event)
	
	if event.is_action_pressed(pp.attack_action):
		set_next_state(pp.charge_state)
	
	if event.is_action_pressed(pp.special_1_action) and character.angry >= 20:
		character.angry -= 20
		set_next_state(pp.defense_state)
