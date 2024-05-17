extends Node

class_name State

@export var 能否跑 : bool = true
@export var 能否转向 : bool = true
@export var 是否无敌 : bool = false

var character : Player
var next_state : State
var playback : AnimationNodeStateMachinePlayback
var pp : PlayerProperty

var return_state : State
var return_animation : String


signal interrupt_state(new_state : State, lambda)

## 回到上一个状态
func return_prev_state(is_use_standard_return : bool = true) -> void: 
	# 变量表示是否播放动画，是否使用标准返回状态
	if is_use_standard_return:  # 如果使用标准返回状态
		if not return_state is GroundState and not return_state is AirState: # 如果当前返回状态不是空中或地面
			if character.is_on_floor():
				return_state = character.ground_state()
				return_animation = character.ground_animation()
			else:
				return_state = pp.air_state
				return_animation = pp.jump_loop_animation
		else:
			if return_state is GroundState and not character.is_on_floor():
				return_state = pp.air_state
				return_animation = pp.jump_loop_animation
				
			if return_state is AirState and character.is_on_floor():
				return_state = character.ground_state()
				return_animation = character.ground_animation()

	next_state = return_state


func set_next_state(new_state : State) -> void:
	next_state = new_state
	new_state.return_state = self
	new_state.return_animation = playback.get_current_node() 

## 先在这里声明，继承在各个类文件里
func state_process(delta) -> void: 
	pass

func state_input(event : InputEvent) -> void:
	pass

func on_enter(lambda = null) -> void:
	pass

func on_exit() -> void:
	pass

func init() -> void:
	pass

func _return() -> void: # 配合return_prev_state函数一起用，主要是继承重写用的
	return_prev_state()
	playback.travel(return_animation)
