extends VBoxContainer

class_name CharacterMenu

@onready var angry_bar : TextureProgressBar = $BH/Bars/AngryBar
@onready var eased_angry_bar : TextureProgressBar = $BH/Bars/AngryBar/EasedAngryBar
@onready var special_bar : TextureProgressBar = $BH/Bars/BulletBar

@onready var head_rect : TextureRect = $BH/Head/TextureRect
@onready var percentage_node : Control = $BP/Percentage
@onready var Break_rect : TextureRect = $BP/TextureRect
@onready var timer : Timer = $BP/TextureRect/Timer # break的timer
@onready var weapon_rect : TextureRect = $BP/Special/TextureRect
@onready var label : Label = $BP/Label

@export var p_label : Label
@export var character : Player
@export var num : int

var break_time : int = 40


signal toggle_FZ_mode()

var head_pics : Dictionary = {  # 人物头像
	"Marston" : preload("res://Assets/CHARAs/MARSTON/Marston.png"),
	"Namka" : preload("res://Assets/CHARAs/NAMKA/Namka.png"),
	"Musashi" : preload("res://Assets/CHARAs/MUSASHI/Musashi.png"),
}

var special_pics : Dictionary = { # 人物special图标
	"Marston" : preload("res://Assets/CHARAs/MARSTON/marston_gun.png"),
	"Namka" : preload("res://Assets/CHARAs/NAMKA/namka_gun.png"),
	"Musashi" : preload("res://Assets/CHARAs/MUSASHI/musashi_defence.png"),
}

var break_pic = preload("res://Assets/FXs/impact1/impact1_1.png")


### menu（和 menu_coll）坐标
const solo_pos : Array[Vector2] = [Vector2(10, 8), Vector2(485, 8)]
const party_2_pos : Array[Vector2] = [Vector2(288, 616), Vector2(768, 616)]
const party_3_pos : Array[Vector2] = [Vector2(288, 616), Vector2(529, 616), Vector2(768, 616)]

''' Solo
(10, 8) : (-237, -150)  P1
(485, 8) : (239, -150)  P2
'''

''' Party
2 Players:
	(288, 616)  P1
	(768, 616)  P2
3 Players:
	(288, 616)  P1
	(529, 616)  P2
	(768, 616)  P3
'''


func _ready():
	## 根据模式配置位置和进度条方向
	if character.scene.mode == "solo":
		global_position = solo_pos[num - 1]
		
		angry_bar.fill_mode = TextureProgressBar.FILL_RIGHT_TO_LEFT if num == 2 else TextureProgressBar.FILL_LEFT_TO_RIGHT        # 设置进度条开始位置
		eased_angry_bar.fill_mode = TextureProgressBar.FILL_RIGHT_TO_LEFT if num == 2 else TextureProgressBar.FILL_LEFT_TO_RIGHT  # 设置进度条开始位置
		special_bar.fill_mode = TextureProgressBar.FILL_RIGHT_TO_LEFT if num == 2 else TextureProgressBar.FILL_LEFT_TO_RIGHT      # 设置进度条开始位置
	
	elif character.scene.mode == "party":
		scale = Vector2(1.5, 1.5)
		
		if character.game_manager.number == 2:
			global_position = party_2_pos[num - 1]
		elif character.game_manager.number == 3:
			global_position = party_3_pos[num - 1]
		
		angry_bar.fill_mode = TextureProgressBar.FILL_LEFT_TO_RIGHT
		eased_angry_bar.fill_mode = TextureProgressBar.FILL_LEFT_TO_RIGHT
		special_bar.fill_mode = TextureProgressBar.FILL_LEFT_TO_RIGHT
	
	
	for key in character.pp.angry_bar_player_signal.keys(): # 找和玩家编号匹配的信号进行连接
		if key == character.pp.player_number:
			SignalBus.connect(character.pp.angry_bar_player_signal[key], _update_angry_bar)
	
	## P-Label图标
	label.text = p_label.text
	label.label_settings = p_label.label_settings
	
	
	## 初始化数值 
	angry_bar.value = 0
	eased_angry_bar.value = 0
	special_bar.value = special_bar.max_value
	
	## 初始化Percentage_Node
	percentage_node.player = character
	
	## 绑定信号
	connect("toggle_FZ_mode", _on_toggle_FZ_mode)
	
	## 设置head、break、special图标
	head_rect.texture = head_pics[character.pp._name]
	Break_rect.texture = break_pic
	weapon_rect.texture = special_pics[character.pp._name]
	
	## 初始化各个角色
	if character.pp._name == "Marston":
		_init_Marston()
	if character.pp._name == "Namka":
		_init_Namka()
	if character.pp._name == "Musashi":
		_init_Musashi()


func _physics_process(delta):
	_handle_break()
	if character.pp._name == "Marston":
		_handle_Marston()
	if character.pp._name == "Namka":
		_handle_Namka()
	if character.pp._name == "Musashi":
		_handle_Musashi()


func _update_angry_bar() -> void:
	var percentage : float = character.angry / 100.000
	angry_bar.value = percentage
	
	## 制作红血条动画
	create_tween().tween_property(eased_angry_bar, "value", percentage, 0.5)



func _handle_break() -> void:        # _physics_process 中处理Break
	if not character.has_Break:      # 交Break了
		if timer.is_stopped():       # 启动timer
			if character.FZ:
				timer.wait_time = break_time / 2.0
			else:
				timer.wait_time = break_time
			
			Break_rect.modulate = Color(1, 1, 1, 0.2)
			timer.start()
			
	if not timer.is_stopped():
		Break_rect.modulate = Color(1, 1, 1, (-(timer.time_left / break_time) * 0.5 + 0.7))


func _on_timer_timeout():            # 接受timer信号，Break回满了
	Break_rect.modulate = Color(1, 1, 1, 1)
	character.has_Break = true

func _on_toggle_FZ_mode() -> void:   # 处理狂热状态
	if not timer.is_stopped():
		if character.FZ:
			timer.wait_time /= 2.0
		else:
			timer.wait_time *= 2.0





func _init_Marston():
	## bullet_bar
	special_bar.max_value = character.bullets_number
	special_bar.value = special_bar.max_value
	#
	#for key in character.pp.bullet_bar_player_signal.keys(): # 找和玩家编号匹配的信号进行连接
		#if key == character.pp.player_number:
			#SignalBus.connect(character.pp.bullet_bar_player_signal[key], func(): special_bar.value = character.bullets_number) # 更新子弹数的函数
	#
	## special图标
	weapon_rect.modulate = Color(1, 1, 1, 0.2)


func _init_Namka():
	## bullet_bar
	special_bar.max_value = character.shot_freeze_timer.wait_time
	
	## special图标
	weapon_rect.modulate = Color(1, 1, 1, 1)


func _init_Musashi():
	## special图标
	weapon_rect.modulate = Color(1, 1, 1, 0.2)
	
	## 蓄力 bar
	special_bar.value = 0



func _handle_Marston():
	## special图标
	if character.is_gun:
		weapon_rect.modulate = Color(1, 1, 1, 1)
	else:
		weapon_rect.modulate = Color(1, 1, 1, 0.2)
	
	## 子弹 bar
	special_bar.value = character.bullets_number

func _handle_Namka():
	## bullet_bar
	special_bar.value = special_bar.max_value - character.shot_freeze_timer.time_left
	
	## special图标
	if character.is_gun:
		weapon_rect.modulate = Color(1, 1, 1, 1)
	else:
		weapon_rect.modulate = Color(1, 1, 1, 0.2)


func _handle_Musashi():
	## 蓄力 bar
	if character.state_machine.current_state is ChargeState:
		special_bar.value = (character.pp.charge_time[character.scene.mode] - character.state_machine.current_state.timer.time_left) / character.state_machine.current_state.timer.wait_time
	else:
		special_bar.value = 0
	
	## special图标
	if character.state_machine.current_state is DefenseState:
		weapon_rect.modulate = Color(1, 1, 1, 1)
	else:
		weapon_rect.modulate = Color(1, 1, 1, 0.2)



func _on_area_2d_body_entered(body : Player):
	get_tree().create_tween().tween_property(self, "modulate", Color(1, 1, 1, 0.2), 0.2).set_ease(Tween.EASE_IN)


func _on_area_2d_body_exited(body : Player):
	get_tree().create_tween().tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2).set_ease(Tween.EASE_OUT)
