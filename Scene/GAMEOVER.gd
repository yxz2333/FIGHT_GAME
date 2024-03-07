extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	hide()
	SignalBus.connect("who_is_winner", _on_who_is_winner)

func _on_who_is_winner(name : String):
	show()
	if name == "NAMKA":
		animation_player.play("NAMKA获胜")
	if name == "MARSTON":
		animation_player.play("MARSTON获胜")
