extends AttackState

@export var attack_1_animation_left : String
@export var attack_1_animation_right : String
@export var attack_2_animation_origin : String
@export var attack_2_animation_left : String
@export var attack_2_animation_right : String

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == attack_1_animation_left:
		playback.travel(attack_2_animation)
	if anim_name == attack_1_animation_right:
		playback.travel(attack_2_animation)
		
	if anim_name == attack_2_animation_left or anim_name == attack_2_animation_right:
		next_state = return_state
		playback.travel(move_animation)
