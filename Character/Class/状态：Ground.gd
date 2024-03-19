extends State

class_name GroundState

@export var air_state : State
@export var attack_state : State
@export var _next_state : State

@export var switch_gun_mode_action : String
@export var jump_action : String
@export var attack_action : String
@export var down_action : String

@export var jump_start_animation : String
@export var jump_loop_animation : String
@export var attack_animation : String
@export var switch_mode_animation : String
@export var move_animation : String

@export var signal_on_whos_jump_return_state : String

@onready var buffer_timer : Timer = $BufferTimer  # 缓冲时间，判断玩家是否在floor上

@export var player_property : PlayerProperty
var jump_velocity : float

func _ready():
	jump_velocity = player_property.jump_velocity

func state_process(delta) -> void:
	if not character.is_on_floor() and buffer_timer.is_stopped(): # buffer判断玩家是否在floor上
		next_state = air_state
		playback.travel(jump_loop_animation)


func state_input(event : InputEvent) -> void: # 读入状态事件

	if event.is_action_pressed(jump_action): 
		return_to_ground_state = self
		return_to_ground_animaton = move_animation
		jump()

	if event.is_action_pressed(attack_action):
		attack()

	if event.is_action_pressed(switch_gun_mode_action):
		next_state = _next_state
		playback.travel(switch_mode_animation)

	if character.is_on_floor() and event.is_action_pressed(down_action): # 单向台阶下落
		air_state.return_to_ground_state = return_to_ground_state
		air_state.return_to_ground_animaton = return_to_ground_animaton # 只能手动改了
		character.position.y += 1



func jump() -> void:
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_start_animation)


func attack() -> void:
	next_state = attack_state
	playback.travel(attack_animation)
