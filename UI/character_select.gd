extends Scene

class_name CharacterSelectMenu

@export var player_cursor_scene : PackedScene
@export var total_players : int
@onready var back_marker = $BackMarker

var back_markers = []
var current_player : int = 1
var vis_player = [] # 存已接入的按键布局


func _ready():
	for child in back_marker.get_children():
		back_markers.append(child)


func _input(event):
	if event.is_action_pressed("ui_accept") and current_player <= total_players:
		connect_input(event)


func connect_input(event):                   # 配置按键，配置手柄键盘按键，初始化选角指针
	if event is InputEventKey:
		if vis_player.find(event.keycode) != -1:
			return
		vis_player.append(event.keycode) # 存按键，防止重复
		print("%s键盘接入" % current_player)

	if event is InputEventJoypadButton:
		if vis_player.find(event.button_index) != -1:
			return
		vis_player.append(event.button_index) # 存按键，防止重复
		print("%s手柄接入" % current_player)
	
	
	## 玩家指针初始化
	var new_player_instantiate = player_cursor_scene.instantiate()
	new_player_instantiate.num = current_player
	new_player_instantiate.menu = self
	
	for i in range(new_player_instantiate.actions.size()):
		new_player_instantiate.actions[i] += str(current_player) # 分配按键
	
	add_child(new_player_instantiate)
	current_player += 1
