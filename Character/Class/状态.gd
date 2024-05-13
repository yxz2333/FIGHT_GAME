extends Node

class_name State

@export var 能否跑 : bool = true
@export var 能否转向 : bool = true
@export var 是否无敌 : bool = false

var character : Player
var next_state : State
var playback : AnimationNodeStateMachinePlayback
var pp : PlayerProperty

signal interrupt_state(new_state : State, lamda)


## 先在这里声明，继承在各个类文件里
func state_process(delta) -> void: 
	pass

func state_input(event : InputEvent) -> void:
	pass

func on_enter(lamda = null) -> void:
	pass

func on_exit() -> void:
	pass

func init() -> void:
	pass
	
func _return() -> void:
	pass
	
