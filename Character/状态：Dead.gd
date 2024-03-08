extends State

@export var kill_weight : float

func on_enter():
	character.weight = kill_weight
