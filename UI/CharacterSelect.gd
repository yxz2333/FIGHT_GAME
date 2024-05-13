extends Scene

class_name CharacterSelectMenu


var cursor_scene : PackedScene = preload("res://UI/PlayerCursor.tscn")

var characters = {
	"Marston" : preload("res://Character/MARSTON/marston.tscn"),
	"Namka" : preload("res://Character/NAMKA/namka.tscn"),
	"Musashi" : "",
}
var label_tres : LabelSettings = preload("res://Character/Class/P_label.tres")

@export var total_players : int
@onready var back_marker = $BackMarker
@onready var timer : Timer = $Timer
@onready var sprite_marker : Node2D = $SpriteMarkers
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var smash_layer = $Smash


var is_playing_enter : bool = false

var current_player : int = 1
var selected_player : int = 0 :
	get:
		return selected_player
	set(value):
		selected_player = value
		if selected_player == total_players:
			anim_player.play("enter_smash")
			is_playing_enter = true
		elif is_playing_enter:
			anim_player.play("exit_smash")
			is_playing_enter = false

var back_markers : Array[Marker2D] = []  # 备选markers
var vis_player = []                      # 存已接入的按键布局

var cursors : Array[PlayerCursor] = []   # 已配置玩家选择指针

func _ready():
	smash_layer.hide()
	
	for child in back_marker.get_children():
		back_markers.append(child)


func _input(event):
	if not timer.is_stopped() or not can_input:
		return
	
	if event.is_action_pressed("accept") and current_player <= total_players:
		_connect_input(event)
	
	if event.is_action_pressed("ui_accept") and selected_player >= total_players:
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
		
		physical_input = event.button_index
		vis_player.append(event.button_index) # 存按键，防止重复
		# print("%s手柄接入" % current_player)
	
	
	## 玩家指针初始化
	var player_cursor = cursor_scene.instantiate()
	player_cursor.init(current_player, self, physical_input, sprite_marker)
	cursors.append(player_cursor)
	
	add_child(player_cursor)
	current_player += 1


func _start_game() -> void:
	can_input = false
	
	Transitions.tran_d_0("res://Scene/Level-1.tscn",
	## lamda函数
	func() -> void:
		var scene_instance = Transitions.packed_scene.instantiate()
		
		## 每个人物初始化
		for i in range(cursors.size()):
			var character = characters.get(cursors[i].selected_UI.name).instantiate() as Player
			character.init(scene_instance.scene, cursors[i].num, cursors[i].input_num)
			character.scale = Vector2(2, 2)
			character.global_position = scene_instance.scene.birth_markers[i].position # 出生点初始化
			scene_instance.scene.add_child(character)
			
			## P_label实例化
			var ls : LabelSettings = label_tres.duplicate()
			character.P_label.text = cursors[i].label.text
			character.P_label.label_settings = ls
			character.P_label.label_settings.font_color = cursors[i].colors[cursors[i].num - 1]
	
		
		get_tree().root.add_child(scene_instance)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = scene_instance
		)  # 默认过渡动画
