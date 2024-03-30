extends GroundState


func on_enter() -> void:
	character.current_ground_state = pp.ground_gun_state
	character.current_ground_animation = pp.ground_gun_animation


func shot() -> void:
	next_state = pp.shot_state
