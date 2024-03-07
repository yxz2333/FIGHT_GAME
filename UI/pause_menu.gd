extends Control

@export var game_manager : GameManager
@onready var resume_button : Button = $Panel/VBoxContainer/ResumeButton


func _ready():
	hide()
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)

func _on_game_manager_toggle_game_paused(is_paused : bool):
	if is_paused:
		show()
		resume_button.grab_focus() # 设置键盘初始焦点
	else:
		hide()


func _on_resume_button_pressed():
	game_manager.game_paused = false


func _on_quit_button_pressed():
	get_tree().quit()  # 关闭游戏
	# 定义一个变量来记录当前的窗口模式


func _on_full_screen_button_pressed():
	SignalBus.switch_screen()


func _on_title_button_pressed():
	game_manager.game_paused = false
	get_tree().change_scene_to_file("res://UI/title_screen.tscn")
