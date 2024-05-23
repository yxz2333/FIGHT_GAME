extends AttackState



func on_enter(lambda = null):
	super()
	attack_input_cnt = 1

func on_exit():
	attack_input_cnt = 0
	timer.stop()

func state_input(event : InputEvent) -> void:
	super(event)
	if event.is_action_pressed(pp.attack_action):
		attack_input_cnt += 1
		timer.start()
	

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == character.pp.attack_1_animation:
		if timer.is_stopped() or attack_input_cnt <= 1:
			_return()
		else:
			playback.travel(character.pp.attack_2_animation)
	
	if anim_name == character.pp.attack_2_animation:
		if timer.is_stopped() or attack_input_cnt <= 2:
			_return()
		else:
			playback.travel(character.pp.attack_3_animation)
		
	if anim_name == character.pp.attack_3_animation:
		_return()
