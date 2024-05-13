extends State

class_name GunStartState

func on_enter(lamda = null):
	playback.travel(pp.gun_start_animation)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == pp.gun_start_animation:
		next_state = pp.ground_gun_state
		playback.travel(pp.ground_gun_animation)
