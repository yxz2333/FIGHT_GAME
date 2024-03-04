extends State

class_name AirState

@export var ground_state : State
@export var double_jump_velocity : float = -150.0

@export var jump_action : String

@export var move_animation : String
@export var jump_animation : String
@export var jump_loop_animation : String
@export var double_jump_animation : String

var has_double_jumped : bool = false 

func state_process(delta) -> void:
	if character.is_on_floor(): # 在地面上时，进入着陆状态
		next_state = ground_state

func state_input(event : InputEvent) -> void: # 读取输入
	if event.is_action_pressed(jump_action) and not has_double_jumped: # 连跳判断
		double_jump()

func on_exit() -> void:
		has_double_jumped = false
		playback.travel(move_animation)

func double_jump() -> void: # 连跳
	character.velocity.y = double_jump_velocity
	has_double_jumped = true
	playback.travel(double_jump_animation)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == jump_animation or anim_name == double_jump_animation:
		playback.travel(jump_loop_animation)
