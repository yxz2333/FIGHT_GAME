extends State

class_name AirState

func state_process(delta) -> void:
	super(delta)
	if character.is_on_floor(): # 在地面上时，进入着陆状态
		set_next_state(character.ground_state())

func state_input(event : InputEvent) -> void:  # 读取输入
	## 连跳
	if event.is_action_pressed(pp.jump_action) and not character.has_double_jumped and 能否跳: 
		double_jump()



func on_exit() -> void:
	if character.is_on_floor():
		playback.travel(character.ground_animation())
		character.on_start_run(character.sprite.flip_h)  # 落地起跑时的灰尘效果

func double_jump() -> void: # 连跳
	character.velocity.y = pp.double_jump_velocity
	character.has_double_jumped = true
	playback.travel(pp.double_jump_animation)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == pp.jump_start_animation or anim_name == pp.double_jump_animation:
		playback.travel(pp.jump_loop_animation)
