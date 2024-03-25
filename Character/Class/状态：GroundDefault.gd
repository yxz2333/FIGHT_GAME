extends GroundState

@export var attack_state : State
@export var attack_animation : String

func attack() -> void:
	next_state = attack_state
	playback.travel(attack_animation)
