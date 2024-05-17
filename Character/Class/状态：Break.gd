extends State

class_name BreakState

@export var break_scene : PackedScene

@onready var timer : Timer = $Timer

var break_instantiate : BreakScene

func _ready():
	timer.wait_time = 0.35
	timer.one_shot = true

func on_enter(lambda = null) -> void:
	timer.start()
	
	playback.travel(pp.break_animation)
	
	break_instantiate = break_scene.instantiate()
	character.add_child(break_instantiate)
	break_instantiate.pp = pp
	break_instantiate.player = character
	break_instantiate.global_position = character.global_position


func state_process(delta) -> void: 
	character.velocity = Vector2.ZERO

func _on_timer_timeout():
	_return()
