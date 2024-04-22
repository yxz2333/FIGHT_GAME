extends Scene

class_name CharacterSelectMenu


var cursor_scene : PackedScene = preload("res://UI/PlayerCursor.tscn")
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
var vis_player = []    # 存已接入的按键布局


func _ready():
	smash_layer.hide()
	
	for child in back_marker.get_children():
		back_markers.append(child)


func _input(event):
	if not timer.is_stopped():
		return
	
	if event.is_action_pressed("ui_accept") and current_player <= total_players:
		_connect_input(event)
	
	if event.is_action_pressed("enter_smash"):
		Transitions.tran_in(self, 0)
		await get_tree().create_timer(0.5).timeout
		Transitions.loading(self, "namka")
		await get_tree().create_timer(1.5).timeout
		Transitions.tran_out(self, 0)
		await get_tree().create_timer(0.5).timeout


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
	
	add_child(player_cursor)
	current_player += 1
