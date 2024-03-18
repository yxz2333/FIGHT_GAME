extends State

class_name GunStartState

@export var gun_start_animation : String
@export var ground_gun_state : State
@export var ground_gun_animation : String

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == gun_start_animation:
		next_state = ground_gun_state
		playback.travel(ground_gun_animation)
