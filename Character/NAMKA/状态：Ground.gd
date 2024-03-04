extends State

extends GroundState

@export var jump_velocity : float = -200.0

@export var air_state : State
@export var ground_state : State
@export var attack_state : State

@export var jump_action : String
@export var attack_action : String

@export var jump_start_animation : String
@export var jump_loop_animation : String
@export var attack_1_animation : String


@onready var buffer_timer : Timer = $BufferTimer  # 缓冲时间，判断玩家是否在floor上


func state_process(delta) -> void:
	if not character.is_on_floor() and buffer_timer.is_stopped(): # buffer判断玩家是否在floor上
		next_state = air_state
		playback.travel(jump_loop_animation)


func state_input(event : InputEvent) -> void: # 读入状态事件
	if event.is_action_pressed(jump_action): 
		jump()
	if event.is_action_pressed(attack_action):
		attack()


func jump() -> void:
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_start_animation)


func attack() -> void:
	next_state = attack_state
	playback.travel(attack_1_animation)
