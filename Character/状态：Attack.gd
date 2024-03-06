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


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(attack_action):
		timer.start()


func _on_animation_tree_animation_finished(anim_name):
	pass
