extends GroundState

@export var attack_animation : String

func attack() -> void:
	next_state = pp.attack_state
	playback.travel(attack_animation)
