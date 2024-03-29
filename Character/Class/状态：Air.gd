extends State

class_name AirState

var double_jump_velocity : float

var has_double_jumped : bool

func init():
	has_double_jumped = false
	double_jump_velocity = pp.double_jump_velocity


func state_process(delta) -> void:
	if character.is_on_floor(): # 在地面上时，进入着陆状态
		next_state = return_to_ground_state

func state_input(event : InputEvent) -> void: # 读取输入
	
	if event.is_action_pressed(pp.jump_action) and not has_double_jumped: # 连跳判断
		double_jump()
	
	if event.is_action_pressed(pp.switch_gun_mode_action):
		next_state = pp.gun_start_state
		playback.travel(pp.gun_start_animation)


func on_exit() -> void:
	has_double_jumped = false
	if character.is_on_floor():
		character.on_start_run(character.sprite.flip_h)  # 起跑时的灰尘效果
	playback.travel(return_to_ground_animaton)

func double_jump() -> void: # 连跳
	character.velocity.y = double_jump_velocity
	has_double_jumped = true
	playback.travel(pp.double_jump_animation)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == pp.jump_start_animation or anim_name == pp.double_jump_animation:
		playback.travel(pp.jump_loop_animation)
