extends State

class_name BreakState

@export var break_scene : PackedScene

@onready var timer : Timer = $Timer

var break_instantiate : BreakScene
var one_chance : bool = true

func _ready():
	timer.wait_time = 0.35
	timer.one_shot = true

func on_enter() -> void:
	timer.start()
	
	playback.travel(pp.break_animation)
	
	break_instantiate = break_scene.instantiate()
	character.add_child(break_instantiate)
	break_instantiate.pp = pp
	break_instantiate.player = character
	break_instantiate.global_position = character.global_position


func if_can_break() -> bool:
	if one_chance: # 默认一次
		one_chance = false
		return true
	elif character.angry >= 50: # 消耗怒气值释放
		character.angry -= 50
		return true
	return false

func state_process(delta) -> void: 
	character.velocity = Vector2.ZERO

func _return() -> void:
	if not character.is_on_floor():
		next_state = pp.air_state
		playback.travel(pp.jump_loop_animation)
	else:
		next_state = character.current_ground_state
		playback.travel(character.current_ground_animation)

func _on_timer_timeout():
	#one_chance = true
	_return()
