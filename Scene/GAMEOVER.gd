extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@export var characters = []

var is_game_over : bool = false

func _ready():
	hide()
	SignalBus.connect("who_is_winner", _on_who_is_winner)


func _on_who_is_winner(name : String) -> void:
	show()
	await get_tree().create_timer(1.5).timeout
	
	var animation_name : String = "%s获胜"
	for character in characters:
		if name == character:
			animation_player.play(animation_name % character) # 格式化字符串
	
	await get_tree().create_timer(0.5).timeout
	is_game_over = true


var cnt : int = 1
func _input(event):
	if event is InputEventKey and is_game_over and cnt:
		cnt -= 1
		get_tree().paused = false
		Transitions.tran_d_0_without_loading("res://UI/mode_select.tscn")
