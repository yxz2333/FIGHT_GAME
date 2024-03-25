extends GroundState

@export var shot_state : State

func shot() -> void:
	next_state = shot_state
