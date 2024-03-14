extends State

@export var player_property : PlayerProperty

func on_enter():
	character.weight = player_property.kill_weight
