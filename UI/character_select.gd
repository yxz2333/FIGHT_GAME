extends Scene

class_name CharacterSelectMenu


var cursor_scene : PackedScene = preload("res://UI/player_cursor.tscn")
@export var total_players : int
@onready var back_marker = $BackMarker

var current_player : int = 1

var back_markers = []  # 备选markers
var vis_player = []    # 存已接入的按键布局


func _ready():
	for child in back_marker.get_children():
		back_markers.append(child)



func _input(event):
	if event.is_action_pressed("ui_accept") and current_player <= total_players:
		_connect_input(event)


func _connect_input(event) -> void:                   # 配置按键，配置手柄键盘按键，初始化选角指针
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
	player_cursor.init(current_player, self, physical_input)
	
	add_child(player_cursor)
	current_player += 1



