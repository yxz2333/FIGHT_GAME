extends State

class_name GroundState


@export var _next_state : State

@export var switch_mode_animation : String

@onready var buffer_timer : Timer = $BufferTimer  # 缓冲时间，判断玩家是否在floor上


func state_process(delta) -> void:
	if not character.is_on_floor() and buffer_timer.is_stopped(): # buffer判断玩家是否在floor上
		next_state = pp.air_state
		playback.travel(pp.jump_loop_animation)


func state_input(event : InputEvent) -> void: # 读入状态事件

	if event.is_action_pressed(pp.jump_action): 
		jump()

	if event.is_action_pressed(pp.attack_action):
		attack()

	if event.is_action_pressed(pp.shot_action):
		shot()

	if event.is_action_pressed(pp.switch_gun_mode_action):
		next_state = _next_state
		playback.travel(switch_mode_animation)

	if character.is_on_floor() and event.is_action_pressed(pp.down_action): # 单向台阶下落
		character.position.y += 1



func jump() -> void:
	character.velocity.y = pp.jump_velocity
	next_state = pp.air_state
	playback.travel(pp.jump_start_animation)


func attack() -> void:
	pass
	
func shot() -> void:
	pass
