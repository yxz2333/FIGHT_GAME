extends State

class_name GroundState


@onready var buffer_timer : Timer = $BufferTimer  # 缓冲时间，判断玩家是否在floor上


func state_process(delta) -> void:
	super(delta)
	if not character.is_on_floor() and buffer_timer.is_stopped(): # buffer判断玩家是否在floor上
		set_next_state(pp.air_state)
		playback.travel(pp.jump_loop_animation)


func state_input(event : InputEvent) -> void: # 读入状态事件
	if event.is_action_pressed(pp.jump_action): 
		jump()

	if character.is_on_floor() and event.is_action_pressed(pp.down_action): # 单向台阶下落
		character.position.y += 1
	
	
	if event.is_action_pressed(pp.switch_gun_mode_action):
		character.is_gun = !character.is_gun
		if character.is_gun:
			set_next_state(character.pp.gun_start_state)
		else:
			set_next_state(character.ground_state())
			playback.travel(character.ground_animation())


func jump() -> void:
	character.velocity.y = pp.jump_velocity
	set_next_state(pp.air_state)
	playback.travel(pp.jump_start_animation)


func attack() -> void:
	pass
	
func shot() -> void:
	pass
