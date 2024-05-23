extends State

class_name AttackState

@export var attack_area : Area2D

@onready var timer : Timer = $Timer

var attack_input_cnt : int = 0     # 攻击段数记录
var jump_input_cnt : bool = false  # 只容许跳一次

func init():
	timer.one_shot = true

func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(pp.jump_action) and jump_input_cnt == false and 能否跳:
		jump()


func on_enter(lambda = null):
	if character.is_on_floor(): # 确保在地面上一定能起跳攻击
		jump_input_cnt = false
	else:                       # 而空中不能再起跳攻击
		jump_input_cnt = true
	
	playback.travel(character.pp.attack_1_animation)


func jump() -> void: # 连跳
	jump_input_cnt = true
	character.velocity.y = pp.jump_velocity
