extends Node2D

@export var player_cursor_scene : PackedScene
@export var total_players : int
var current_player : int = 1

var vis_player = [] # 存已接入的按键布局

func _input(event):
	connect_input(event)

func connect_input(event):
	if event.is_action_pressed("ui_accept") and current_player <= total_players:
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
	
		
		var new_player_instantiate = player_cursor_scene.instantiate()
		new_player_instantiate.num = current_player
		
		
		for i in range(new_player_instantiate.actions.size()):
			new_player_instantiate.actions[i] += str(current_player)
		
		add_child(new_player_instantiate)
		current_player += 1
