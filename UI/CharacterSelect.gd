extends Scene

class_name CharacterSelectMenu

var cursor_scene : PackedScene = preload("res://UI/PlayerCursor.tscn")

var characters = {
	"Marston" : preload("res://Character/MARSTON/marston.tscn"),
	"Namka" : preload("res://Character/NAMKA/namka.tscn"),
	"Musashi" : preload("res://Character/MUSASHI/musashi.tscn"),
}
var label_tres : LabelSettings = preload("res://Character/Class/P_label.tres")


var total_players : int
@export_enum("solo", "party") var next_mode : String

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var smash_layer = $Smash

@onready var solo_sprite_marker  : Node2D = $SoloSpriteMarkers
@onready var party_sprite_marker : Node2D = $PartySpriteMarkers

@onready var solo_back_marker = $SoloBackMarkers
@onready var party_back_marker = $PartyBackMarkers

var is_playing_enter : bool = false
var is_platform_up   : bool = false

var current_player : int = 1
var selected_player : int = 0 :
	get:
		return selected_player
	set(value):
		selected_player = value
		if selected_player >= 2 and not is_playing_enter:
			anim_player.play("enter_smash")
			is_playing_enter = true
		elif selected_player < 2 and is_playing_enter:
			anim_player.play("exit_smash")
			is_playing_enter = false


var back_markers : Array[Marker2D] = []  # 指针隐藏的返回markers
var vis_player = []                      # 存已接入的按键布局

var cursors : Array[PlayerCursor] = []   # 已配置玩家选择指针

signal player_out_of_screen(node : Player) # 出屏幕


func init(m : String) -> void:
	next_mode = m


func _ready():
	super()
	
	smash_layer.hide()
	
	if next_mode == "solo":
		total_players = 2
		for child in solo_back_marker.get_children():
			back_markers.append(child)
		
	elif next_mode == "party":
		total_players = 3
		for child in party_back_marker.get_children():
			back_markers.append(child)


func _input(event):
	if not can_input:
		return
	if event is InputEventJoypadButton:
		print(event.device)
	if event.is_action_pressed("accept") and current_player <= total_players:
		_connect_input(event)
	
	if event.is_action_pressed("ui_accept") and selected_player >= 2:
		_start_game()


func _connect_input(event) -> void:                 # 配置指针按键，初始化选角指针
	var physical_input
	
	if event is InputEventKey:
		if vis_player.find(event.keycode) != -1:
			return
		
		physical_input = event.keycode
		vis_player.append(event.keycode)      # 存按键，防止重复
		# print("%s键盘接入" % current_player)

	if event is InputEventJoypadButton:
		if vis_player.find(event.button_index) != -1:
			return
			
		print(event.button_index)
		physical_input = event.button_index
		vis_player.append(event.button_index) # 存按键，防止重复
		print("%s手柄接入" % current_player)
	
	
	## 玩家指针初始化
	if next_mode == "party" and not is_platform_up:
		anim_player.play("party_platform_up")
	is_platform_up = true
	
	var player_cursor = cursor_scene.instantiate()
	if next_mode == "solo":
		player_cursor.init(current_player, self, physical_input, solo_sprite_marker)
	if next_mode == "party":
		player_cursor.init(current_player, self, physical_input, party_sprite_marker)
	cursors.append(player_cursor)
	
	add_child(player_cursor)
	current_player += 1


## 转场时用的lambda函数
var _start_game_lambda : Callable = func() -> void: 
		var scene_instance = Transitions.packed_scene.instantiate() # GameManager实例化
		
		scene_instance.mode = next_mode
		
		## create_character(scene, num, input_num)
		## 每个人物初始化
		for i in range(cursors.size()):
			if cursors[i].selected_UI == null:  # 已选好人物的指针
				continue
			
			var character = characters[cursors[i].selected_UI.name].instantiate() as Player
			character.init(scene_instance.scene, cursors[i].num, cursors[i].input_num)
			character.scale = Vector2(2, 2)
			character.global_position = scene_instance.scene.birth_markers[i].position # 出生点初始化
			scene_instance.scene.add_child(character)
			
			## P_label实例化
			var ls : LabelSettings = label_tres.duplicate()
			character.P_label.text = cursors[i].label.text
			character.P_label.label_settings = ls
			character.P_label.label_settings.font_color = cursors[i].colors[cursors[i].num - 1]
			
			if next_mode == "party":
				scene_instance.scene.phantom_camera.append_follow_targets(character)
			
			## 实例化的人物录入GameManager
			scene_instance.players.append(character)
			scene_instance.number += 1
			

		
		## 新场景实例化要自己写 
		get_tree().root.add_child(scene_instance)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = scene_instance




func _start_game() -> void:
	can_input = false
	
	if next_mode == "solo":
		Transitions.tran_d_0("res://Scene/Solo/Level-1.tscn", _start_game_lambda)  # 默认过渡动画
	elif next_mode == "party":
		Transitions.tran_d_0("res://Scene/Party/Level-2.tscn", _start_game_lambda)  # 默认过渡动画


func _on_limit_area_body_exited(body : Player):
	emit_signal("player_out_of_screen", body)
