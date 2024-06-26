extends Node

#### 全局信号发送
signal angry_bar_change_player_1() # ui（怒气值、百分比）变化
signal angry_bar_change_player_2() # ui（怒气值、百分比）变化
signal angry_bar_change_player_3() # ui（怒气值、百分比）变化
signal angry_bar_change_player_4() # ui（怒气值、百分比）变化

signal bullet_bar_change_player_1() # ui（怒气值、百分比）变化
signal bullet_bar_change_player_2() # ui（怒气值、百分比）变化
signal bullet_bar_change_player_3() # ui（怒气值、百分比）变化
signal bullet_bar_change_player_4() # ui（怒气值、百分比）变化



var window_mode = DisplayServer.WINDOW_MODE_WINDOWED

func switch_screen() -> void:
	# 如果当前是窗口化模式，就切换到全屏模式
	if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	# 如果当前是全屏模式，就切换到窗口化模式，并设置窗口大小
	elif window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2(1280, 720))
		window_mode = DisplayServer.WINDOW_MODE_WINDOWED
