extends HBoxContainer

@export var character : Player

@onready var angry_bar : TextureProgressBar = $AngryBar
@onready var eased_angry_bar : TextureProgressBar = $AngryBar/EasedAngryBar

@export var is_right : bool

func _ready():
	scale = Vector2(0.75, 0.75)
	global_position = Vector2(490 if is_right else 10, 8)
	
	for key in character.pp.player_signal.keys(): # 找和玩家编号匹配的信号进行连接
		if key == character.pp.player_number:
			SignalBus.connect(character.pp.player_signal[key], _update_angry_bar)
			
	angry_bar.value = 0
	eased_angry_bar.value = 0

func _update_angry_bar() -> void:
	var percentage : float = character.angry / 100.0
	angry_bar.value = percentage
	
	## 制作红血条动画
	create_tween().tween_property(eased_angry_bar, "value", percentage, 0.5)
