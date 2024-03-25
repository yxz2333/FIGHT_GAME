extends State

class_name ShotState

@export var shot_action : String
@export var shot_animation : String
@export var bullet : PackedScene
@export var player : Player
@export var bullet_start_marker : Marker2D
@export var anim_player : AnimationPlayer
@export var character_state_machine : CharacterStateMachine

var direction : int

func _return() -> void:
	next_state = return_to_ground_state
	playback.travel(return_to_ground_animaton)

func on_enter() -> void:
	if player.sprite.flip_h == false:
		bullet_start_marker.position.x = abs(bullet_start_marker.position.x)
	else:
		bullet_start_marker.position.x = -abs(bullet_start_marker.position.x)
