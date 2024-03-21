extends State

class_name AirState

@export var jump_action : String

@export var jump_animation : String
@export var jump_loop_animation : String
@export var double_jump_animation : String
@export var signal_on_whos_jump_return_state : String

var double_jump_velocity : float

var has_double_jumped : bool

func _ready():
	has_double_jumped = false
	double_jump_velocity = player_property.jump_velocity


func state_process(delta) -> void:
	if character.is_on_floor(): # 在地面上时，进入着陆状态
		next_state = return_to_ground_state

func state_input(event : InputEvent) -> void: # 读取输入
	if event.is_action_pressed(jump_action) and not has_double_jumped: # 连跳判断
		double_jump()

func on_exit() -> void:
	has_double_jumped = false
	character.on_start_run(character.sprite.flip_h)  # 起跑时的灰尘效果
	playback.travel(return_to_ground_animaton)

func double_jump() -> void: # 连跳
	character.velocity.y = double_jump_velocity
	has_double_jumped = true
	playback.travel(double_jump_animation)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == jump_animation or anim_name == double_jump_animation:
		playback.travel(jump_loop_animation)
