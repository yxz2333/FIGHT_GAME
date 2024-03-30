extends State

class_name AttackState

@export var attack_1_animation : String
@export var attack_2_animation : String
@export var attack_3_animation : String

@export var attack_area : Area2D

@onready var timer : Timer = $Timer

var attack_input_cnt : int = 0

func init():
	timer.one_shot = true

func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(pp.jump_action):
		jump()

func on_enter():
	playback.travel(attack_1_animation)

func jump():
	character.velocity.y = pp.jump_velocity
