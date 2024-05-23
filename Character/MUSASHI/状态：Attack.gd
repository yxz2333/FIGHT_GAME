extends AttackState


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == pp.attack_1_animation:
		_return()
