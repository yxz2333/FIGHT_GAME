extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

var is_game_over : bool = false

func _ready():
	hide()
	SignalBus.connect("who_is_winner", _on_who_is_winner)

func _on_who_is_winner(name : String):
	show()
	await  get_tree().create_timer(1.5).timeout
	if name == "NAMKA":
		animation_player.play("NAMKA获胜")
	if name == "MARSTON":
		animation_player.play("MARSTON获胜")
		
	await get_tree().create_timer(0.5).timeout
	is_game_over = true

func _input(event):
	if event is InputEventKey and is_game_over:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://UI/title_menu.tscn")
