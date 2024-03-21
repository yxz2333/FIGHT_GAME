extends State

class_name AttackState

@export var return_state : State

@export var attack_action : String

@export var move_animation : String
@export var attack_1_animation : String
@export var attack_2_animation : String
@export var attack_3_animation : String

@export var attack_area : Area2D

@onready var timer : Timer = $Timer

var attack_input_cnt : int = 0

func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(attack_action):
		attack_input_cnt += 1
		timer.start()


func _on_animation_tree_animation_finished(anim_name):
	pass

func on_enter():
	attack_input_cnt = 1

func on_exit():
	attack_input_cnt = 0
	timer.stop()
