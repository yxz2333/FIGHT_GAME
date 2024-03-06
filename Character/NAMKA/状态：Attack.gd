extends AttackState

@export var attack_1_animation_left : String
@export var attack_1_animation_right : String
@export var attack_2_animation_origin : String
@export var attack_2_animation_left : String
@export var attack_2_animation_right : String


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("3_cancel"):
		attack_area.monitoring = false
		next_state = return_state
		playback.travel("移动")
		
	

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == attack_1_animation_left:
		playback.travel(attack_2_animation)
	if anim_name == attack_1_animation_right:
		playback.travel(attack_2_animation)
		
	if anim_name == attack_2_animation_left or anim_name == attack_2_animation_right:
		next_state = return_state
		playback.travel(move_animation)
