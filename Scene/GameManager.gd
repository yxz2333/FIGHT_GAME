extends Node

class_name GameManager

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var scene : Scene 
@export var game_set_animation : String = "game_set"
@export_enum("solo", "party", "character_select") var mode : String
@export var players : Array[Player]

var is_game_over : bool = false

## gameset镜头震动相关
@export var game_over_camera_shake_offset : Vector2 = Vector2(0, -3)  # 镜头偏移量
@export var game_over_camera_shake_zoom : Vector2 = Vector2(1, 0.9)   # 镜头缩放
@export var game_over_camera_shake_duration : float = 0.02            # 镜头缩放

## 暂停游戏菜单相关
signal toggle_game_paused(is_paused : bool) # 是否暂停游戏的信号
var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused) # 向pause_menu.gd发出信号


## 开发者模式相关
signal toggle_debug_ui(is_debugging : bool) # 是否暂停游戏的信号
var is_debugging : bool = false:
	get:
		return is_debugging
	set(value):
		is_debugging = value
		emit_signal("toggle_debug_ui", is_debugging) # 向TestUI.gd发出信号


signal player_out_of_screen(node : Player) # 出屏幕
signal who_is_winner(name : String) # 胜者


func _ready():
	self.get_viewport().set_embedding_subwindows(false)   # 创建新窗口一定要这句代码
	
	if mode == "party":
		ProjectSettings.set_setting("display/window/stretch/scale", 1.0) # 改变缩放
	
	connect("player_out_of_screen", _one_player_is_out) # 连接player.gd发出的信号



func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel") and not is_game_over: # 开关暂停菜单
		game_paused = !game_paused
		
	if event.is_action_pressed("debug_mode"):  # 开关开发者模式
		is_debugging = !is_debugging


func _one_player_is_out(node : Player) -> void:
	if is_game_over:
		return
	
	scene.create_out(node) # 生成out
	
	node.queue_free()
	
	var winner : Player = check_if_gameover() 
	
	scene.camera.camera_shake(game_over_camera_shake_offset, game_over_camera_shake_zoom, game_over_camera_shake_duration)
	
	if winner != null:
		print(winner)
		game_set_then_game_over(winner)


func check_if_gameover() -> Player:    # 检查是否只有一位玩家幸存，即检查游戏是否结束
	var cnt : int = 0
	var winner : Player = null
	for player in players:
		if not player.is_queued_for_deletion():
			print(player)
			cnt += 1
			winner = player
	if cnt == 1:
		is_game_over = true
	
	return winner


func game_set_then_game_over(winner : Player) -> void:   # gameset和gameover
	animation_player.play(game_set_animation) 
	
	await get_tree().create_timer(0.4).timeout # 等待0.4秒
	
	get_tree().paused = true
	
	await get_tree().create_timer(2).timeout # 等待2秒
	
	animation_player.play("RESET") # reset就是黑屏
	
	emit_signal("who_is_winner", winner.pp.player_number) # 信号发送给gameover.gd
