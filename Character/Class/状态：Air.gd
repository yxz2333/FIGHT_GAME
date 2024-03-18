extends State

class_name AirState

@export var ground_state : State
@export var ground_animation : String

@export var jump_action : String

@export var jump_animation : String
@export var jump_loop_animation : String
@export var double_jump_animation : String

@export var player_property : PlayerProperty
var double_jump_velocity : float

var has_double_jumped : bool = false

var return_state : State
var return_animation : String

func _ready():
	return_state = ground_state
	return_animation = ground_animation
	double_jump_velocity = player_property.jump_velocity
	SignalBus.connect("which_state_jump_return", _on_which_state_jump_return)

func _on_which_state_jump_return(_return_state : State, _return_animation : String):
	return_state = _return_state
	return_animation = _return_animation

func state_process(delta) -> void:
	if character.is_on_floor(): # 在地面上时，进入着陆状态
		next_state = return_state

func state_input(event : InputEvent) -> void: # 读取输入
	if event.is_action_pressed(jump_action) and not has_double_jumped: # 连跳判断
		double_jump()

func on_exit() -> void:
	has_double_jumped = false
	playback.travel(return_animation)

func double_jump() -> void: # 连跳
	character.velocity.y = double_jump_velocity
	has_double_jumped = true
	playback.travel(double_jump_animation)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == jump_animation or anim_name == double_jump_animation:
		playback.travel(jump_loop_animation)
