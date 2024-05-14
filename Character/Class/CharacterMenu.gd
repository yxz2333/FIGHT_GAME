extends HBoxContainer

class_name CharacterMenu

@export var character : Player

@onready var angry_bar : TextureProgressBar = $BH/Bars/AngryBar
@onready var eased_angry_bar : TextureProgressBar = $BH/Bars/AngryBar/EasedAngryBar
@onready var bullet_bar : TextureProgressBar = $BH/Bars/BulletBar
@onready var texture_rect : TextureRect = $BH/Head/TextureRect
@onready var percentage_node : Control = $BP/Percentage

@onready var timer : Timer = $BP/TextureRect/Timer # break的timer

@export var is_right : bool

var break_time : int = 40


signal toggle_FZ_mode()

var pics : Dictionary = {  # 人物头像
	"Marston" : preload("res://Assets/CHARAs/MARSTON/Marston.png"),
	"Namka" : preload("res://Assets/CHARAs/NAMKA/Namka.png"),
	"Musashi" : preload("res://Assets/CHARAs/MUSASHI/Musashi.png"),
}

var break_pics : Array = [ # break动画
	preload("res://Assets/FXs/impact1/impact1_2.png"),
	preload("res://Assets/FXs/impact1/impact1_3.png"),
	preload("res://Assets/FXs/impact1/impact1_4.png"),
	preload("res://Assets/FXs/impact1/impact1_1.png"),
]


func _ready():
	global_position = Vector2(475 if is_right else 10, 8) # 设置左右位置
	angry_bar.fill_mode = TextureProgressBar.FILL_RIGHT_TO_LEFT if is_right else TextureProgressBar.FILL_LEFT_TO_RIGHT        # 设置进度条开始位置
	eased_angry_bar.fill_mode = TextureProgressBar.FILL_RIGHT_TO_LEFT if is_right else TextureProgressBar.FILL_LEFT_TO_RIGHT  # 设置进度条开始位置
	bullet_bar.fill_mode = TextureProgressBar.FILL_RIGHT_TO_LEFT if is_right else TextureProgressBar.FILL_LEFT_TO_RIGHT       # 设置进度条开始位置
	
	for key in character.pp.angry_bar_player_signal.keys(): # 找和玩家编号匹配的信号进行连接
		if key == character.pp.player_number:
			SignalBus.connect(character.pp.angry_bar_player_signal[key], _update_angry_bar)
	
	texture_rect.texture = pics.get(character.pp._name)     # 设置头像图
	
	## 初始化数值 
	angry_bar.value = 0
	eased_angry_bar.value = 0
	bullet_bar.value = bullet_bar.max_value
	
	## 初始化Percentage_Node
	percentage_node.player = character
	
	## 绑定信号
	connect("toggle_FZ_mode", _on_toggle_FZ_mode)


func _update_angry_bar() -> void:
	var percentage : float = character.angry / 100.000
	angry_bar.value = percentage
	
	## 制作红血条动画
	create_tween().tween_property(eased_angry_bar, "value", percentage, 0.5)


func _physics_process(delta):
	if not character.has_Break: # 交Break了
		if timer.is_stopped():  # 启动timer
			if character.FZ:
				timer.wait_time = break_time / 2.0
			else:
				timer.wait_time = break_time
			timer.start()


func _on_toggle_FZ_mode() -> void:
	if not timer.is_stopped():
		if character.FZ:
			timer.wait_time /= 2.0
		else:
			timer.wait_time *= 2.0
