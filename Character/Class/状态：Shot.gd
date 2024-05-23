extends State

class_name ShotState

@export var player : Player
@export var bullet_start_marker : Marker2D
@export var anim_player : AnimationPlayer
@export var character_state_machine : CharacterStateMachine

var direction : int
var bullet : PackedScene

func init():
	bullet = pp.bullet


func on_enter(lambda = null) -> void:
	if player.sprite.flip_h == false:
		bullet_start_marker.position.x = abs(bullet_start_marker.position.x)
	else:
		bullet_start_marker.position.x = -abs(bullet_start_marker.position.x)

func state_input(event : InputEvent) -> void:
	if character.is_on_floor() and event.is_action_pressed(pp.jump_action) and 能否跳:
		set_next_state(pp.air_state)
		character.ground_state().jump()
