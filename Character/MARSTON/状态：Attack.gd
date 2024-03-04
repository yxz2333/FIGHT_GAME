extends AttackState


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == attack_1_animation:
		if timer.is_stopped():          # 其实个人感觉这样写攻击切换逻辑不太好，因为这样timer必须在这个(0.2s,0.4s)区间内（攻击动画本身4帧）
			next_state = return_state
			playback.travel(move_animation)
		else:
			playback.travel(attack_2_animation)
	
	if anim_name == attack_2_animation:
		if timer.is_stopped():
			next_state = return_state
			playback.travel(move_animation)
		else:
			playback.travel(attack_3_animation)
		
	if anim_name == attack_3_animation:
		next_state = return_state
		playback.travel(move_animation)
