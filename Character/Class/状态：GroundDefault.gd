extends GroundState

@export var attack_animation : String

func on_enter(lamda = null) -> void:
	character.current_ground_state = pp.ground_default_state
	character.current_ground_animation = pp.move_animation

func attack() -> void:
	next_state = pp.attack_state
