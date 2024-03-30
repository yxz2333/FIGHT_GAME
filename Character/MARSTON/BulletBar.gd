extends TextureProgressBar

@export var bus : AngryBar

func _ready():
	value = bus.character.bullets_number
	max_value = bus.character.bullets_number
	
	for key in bus.character.pp.bullet_bar_player_signal.keys(): # 找和玩家编号匹配的信号进行连接
		if key == bus.character.pp.player_number:
			SignalBus.connect(bus.character.pp.bullet_bar_player_signal[key], _update_bullet_bar)

func _update_bullet_bar():
	value = bus.character.bullets_number
