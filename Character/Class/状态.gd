extends Node

class_name State

@export var 能否跑 : bool = true
@export var 能否转向 : bool = true

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

