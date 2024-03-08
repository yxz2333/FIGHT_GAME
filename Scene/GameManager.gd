extends Node

class_name GameManager

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var camera_shake_offset : Vector2 # 镜头偏移量
@export var camera_shake_zoom : Vector2 # 镜头缩放
@export var camera_shake_duration : float # 镜头缩放
@export var game_set_animation : String

var is_game_over : bool = false

signal toggle_game_paused(is_paused : bool) # 是否暂停游戏的信号

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _ready():
	SignalBus.connect("player_out_of_screen", _game_over)

func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel") and not is_game_over:
		game_paused = !game_paused    # 切换游戏是否暂停

func _game_over(node : CharacterBody2D):
	is_game_over = true
	
	CameraSetting.camera_shake(camera_shake_offset, camera_shake_zoom, camera_shake_duration)
	animation_player.play(game_set_animation) 
	
	await get_tree().create_timer(0.4).timeout # 等待0.4秒
	
	get_tree().paused = true
	
	await get_tree().create_timer(2).timeout # 等待0.4秒
	
	animation_player.play("RESET") 
	if node.name == "NAMKA":
		SignalBus.emit_signal("who_is_winner", "MARSTON")
	if node.name == "MARSTON":
		SignalBus.emit_signal("who_is_winner", "NAMKA")
