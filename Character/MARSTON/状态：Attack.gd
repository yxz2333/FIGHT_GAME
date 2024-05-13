extends AttackState


@export var attack_2_animation : String = "攻击_2"
@export var attack_3_animation : String = "攻击_3"


func on_enter(lamda = null):
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
	if anim_name == attack_1_animation:
		if timer.is_stopped() or attack_input_cnt <= 1:
			next_state = character.current_ground_state
			playback.travel(character.current_ground_animation)
		else:
			playback.travel(attack_2_animation)
	
	if anim_name == attack_2_animation:
		if timer.is_stopped() or attack_input_cnt <= 2:
			next_state = character.current_ground_state
			playback.travel(character.current_ground_animation)
		else:
			playback.travel(attack_3_animation)
		
	if anim_name == attack_3_animation:
		next_state = character.current_ground_state
		playback.travel(character.current_ground_animation)
