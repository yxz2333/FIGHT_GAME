extends Node

class_name State

@export var player_property : PlayerProperty

@export var 能否跑 : bool = true
@export var 能否转向 : bool = true


####记得用字典整理一下变量
var return_to_ground_state : State
var return_to_ground_animaton : String

var character : CharacterBody2D
var next_state : State
var playback : AnimationNodeStateMachinePlayback

signal interrupt_state(new_state : State)

## 先在这里声明，继承在各个类文件里
func state_process(delta) -> void: 
	pass

func state_input(event : InputEvent) -> void:
	pass

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

