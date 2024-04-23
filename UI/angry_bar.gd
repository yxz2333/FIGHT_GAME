extends HBoxContainer

class_name AngryBar

@export var character : Player

@onready var angry_bar : TextureProgressBar = $VBoxContainer/AngryBar
@onready var eased_angry_bar : TextureProgressBar = $VBoxContainer/AngryBar/EasedAngryBar
@onready var bullet_bar : TextureProgressBar = $VBoxContainer/BulletBar
@onready var texture_rect : TextureRect = $PanelContainer/TextureRect
@export var pic : Texture2D
@export var is_right : bool

func _ready():
	scale = Vector2(0.75, 0.75)
	
	global_position = Vector2(470 if is_right else 10, 8) # 设置左右位置
	angry_bar.fill_mode = TextureProgressBar.FILL_RIGHT_TO_LEFT if is_right else TextureProgressBar.FILL_LEFT_TO_RIGHT        # 设置进度条开始位置
	eased_angry_bar.fill_mode = TextureProgressBar.FILL_RIGHT_TO_LEFT if is_right else TextureProgressBar.FILL_LEFT_TO_RIGHT  # 设置进度条开始位置
	bullet_bar.fill_mode = TextureProgressBar.FILL_RIGHT_TO_LEFT if is_right else TextureProgressBar.FILL_LEFT_TO_RIGHT       # 设置进度条开始位置
	
	for key in character.pp.angry_bar_player_signal.keys(): # 找和玩家编号匹配的信号进行连接
		if key == character.pp.player_number:
			SignalBus.connect(character.pp.angry_bar_player_signal[key], _update_angry_bar)
	
	texture_rect.texture = pic
	angry_bar.value = 0
	eased_angry_bar.value = 0
	bullet_bar.value = bullet_bar.max_value

func _update_angry_bar() -> void:
	var percentage : float = character.angry / 100.0
	angry_bar.value = percentage
	
	## 制作红血条动画
	create_tween().tween_property(eased_angry_bar, "value", percentage, 0.5)
