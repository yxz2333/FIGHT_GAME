extends TextureProgressBar


class_name BulletBar

@export var bus : AngryBar


func _ready():
	if bus.character.pp._name == "Marston":
		value = bus.character.bullets_number
		max_value = bus.character.bullets_number
		
		for key in bus.character.pp.bullet_bar_player_signal.keys(): # 找和玩家编号匹配的信号进行连接
			if key == bus.character.pp.player_number:
				SignalBus.connect(bus.character.pp.bullet_bar_player_signal[key], _update_bullet_bar)
	
	if bus.character.pp._name == "Namka":
		max_value = bus.character.shot_freeze_timer.wait_time


func _update_bullet_bar():
	if bus.character.pp._name == "Marston":
		value = bus.character.bullets_number


func _physics_process(delta):
	if bus.character.pp._name == "Namka":
		value = max_value - bus.character.shot_freeze_timer.time_left
