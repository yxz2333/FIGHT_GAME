extends AttackState


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == attack_1_animation:
		if timer.is_stopped() or attack_input_cnt <= 1:
			next_state = return_state
			playback.travel(move_animation)
		else:
			playback.travel(attack_2_animation)
	
	if anim_name == attack_2_animation:
		if timer.is_stopped() or attack_input_cnt <= 2:
			next_state = return_state
			playback.travel(move_animation)
		else:
			playback.travel(attack_3_animation)
		
	if anim_name == attack_3_animation:
		next_state = return_state
		playback.travel(move_animation)
