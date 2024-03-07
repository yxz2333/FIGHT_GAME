extends Node

class_name GameManager

signal toggle_game_paused(is_paused : bool) # 发出是否暂停游戏的信号

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused    # 切换游戏是否暂停
