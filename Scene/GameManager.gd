extends Node

class_name GameManager

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var out : PackedScene
@export var scene : Scene 
@export var game_set_animation : String = "game_set"

@export var birth_position : Array[Marker2D] = []

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


func _ready():
	SignalBus.connect("player_out_of_screen", _game_over) # 连接player.gd发出的信号


func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel") and not is_game_over:
		game_paused = !game_paused    # 切换游戏是否暂停


func _game_over(node : Player):
	is_game_over = true
	
	game_over_out(node) # 生成out
	
	var node_name : String = node.pp._name
	node.queue_free()
	
	CameraSetting.camera_shake(game_over_camera_shake_offset, game_over_camera_shake_zoom, game_over_camera_shake_duration)
	game_set_then_game_over(node_name)


func game_over_out(node : Player) -> void:                  # 生成out特效
	var out_instance = out.instantiate()
	
	
	## 设置out位置
	if node.global_position.y < scene.tilemap_limit_bottom:
		out_instance.rotation_degrees = 0.0
		if node.global_position.x < 0:
			out_instance.flip_h = false
			out_instance.global_position = Vector2(-90, node.global_position.y)
		elif node.global_position.x > 0:
			out_instance.flip_h = true
			out_instance.global_position = Vector2( 90, node.global_position.y)
	add_sibling(out_instance)
	await get_tree().create_timer(0.25).timeout # 等待0.25秒
	out_instance.queue_free()


func game_set_then_game_over(node_name : String) -> void:   # gameset和gameover
	animation_player.play(game_set_animation) 
	
	await get_tree().create_timer(0.4).timeout # 等待0.4秒
	
	get_tree().paused = true
	
	await get_tree().create_timer(2).timeout # 等待2秒
	
	animation_player.play("RESET") # reset就是黑屏
	if node_name == "Namka":
		SignalBus.emit_signal("who_is_winner", "MARSTON") # 信号发送给gameover.gd
	if node_name == "Marston":
		SignalBus.emit_signal("who_is_winner", "NAMKA")   # 信号发送给gameover.gd
