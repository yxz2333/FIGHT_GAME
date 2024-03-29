extends State

class_name AttackState

@export var return_state : State

@export var move_animation : String
@export var attack_1_animation : String
@export var attack_2_animation : String
@export var attack_3_animation : String

@export var attack_area : Area2D

@onready var timer : Timer = $Timer

var attack_input_cnt : int = 0

func init():
	timer.one_shot = true

func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(pp.attack_action):
		attack_input_cnt += 1
		timer.start()

func on_enter():
	attack_input_cnt = 1

func on_exit():
	attack_input_cnt = 0
	timer.stop()
