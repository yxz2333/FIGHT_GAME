extends CharacterBody2D

class_name Player


var game_manager : GameManager
@export var scene : Scene
var camera_setting : Node2D
var run_start_effect : PackedScene = preload("res://Character/Class/run_start_effect.tscn")
@export var pp : PlayerProperty
@export var sprite : Sprite2D
@export var P_label : Label
@export var canvas_layer : CanvasLayer
@export var anim_player : AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree
var playback : AnimationNodeStateMachinePlayback  # 获取当前动画用
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var run_start_marker : Marker2D = $Markers/RunStart
@onready var trail_timer : Timer = $TrailTimer

var character_menu : Array[CharacterMenu]

var direction : Vector2 = Vector2.ZERO # 读入键盘手柄输入用
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # 获取项目设置里设置的重力大小

signal facing_direction_changed(facing_right : bool)

var DI_timer : Timer
var SA_timer : Timer

## 动态更新属性
var has_double_jumped : bool = false        # 是否二段跳
var SA : bool = false                       # 是否霸体
var FZ : bool = false :                     # 是否狂热状态（FZ）
	get:
		return FZ
	set(value):
		FZ = value
		for menu in character_menu:
			menu.emit_signal("toggle_FZ_mode")
			
var has_Break : bool = true                 # 是否有Break
var fixed_percentage : bool = false         # 是否固定百分比
var fixed_angry : bool = false              # 是否固定怒气值
var is_dead : bool = 0                      # 是否已死
var life : int = 1
var speed : float                           # 速度
var percentage : float = 0.0 :              # 百分比
	get:
		return percentage
	set(value):
		if not fixed_percentage:
			percentage = value

var angry : int = 0.0 :                     # 怒气值
	get:
		return angry
	set(value):
		if value >= 100:
			value = 100
		if value <= 0:
			value = 0
			
		if not fixed_angry:
			angry = value
			for key in pp.angry_bar_player_signal.keys(): # 找和玩家编号匹配的信号进行发送
				if key == pp.player_number:
					SignalBus.emit_signal(pp.angry_bar_player_signal[key])


func init(s : Scene, pn : int, input_c):
	scene = s
	camera_setting = scene.camera
	pp.player_number = pn
	pp.init_input(input_c)
	
	if scene.mode != "character_select":
		game_manager = scene.game_manager
		life = 3


func _ready():
	## 变量初始化
	speed = pp.speed
	
	## 动画树绑定、激活
	playback = animation_tree["parameters/playback"]
	animation_tree.active = true
	
	DI_timer_init() 
	SA_timer_init()
	trail_timer_init()


func _physics_process(delta):
	## 没编号的报错
	if pp.player_number == null:
		push_warning("人物错误初始化")
		return
	
	## 只允许下落的转场禁输入
	if scene.mode != "character_select":
		if not scene.game_manager.timer.is_stopped():
			## 只允许下落
			if not is_on_floor(): 
				velocity.y += gravity * delta 
			else:
				has_double_jumped = false
			move_and_slide()
			return
	
	if is_dead or not scene.can_input:
		return

	## 读入x轴和y轴方向输入
	direction = Input.get_vector(pp.left_action, pp.right_action, pp.up_action, pp.down_action)
	
	## 能否break
	if Input.is_action_pressed(pp.break_action) and not SA and state_machine.current_state != pp.break_state and has_Break:
		break_skill()
	
	## 能否SA
	if Input.is_action_pressed(pp.SA_action) and angry == 100:
		SA_state()
	
	## 如果处于SA状态
	if SA:
		if SA_timer.is_stopped():
			SA = false
			trail_timer.stop()
			angry = 0
			speed = pp.speed
		else:   # 怒气值变化
			angry = SA_timer.time_left / SA_timer.wait_time * 100
	
	## 能否DI
	if check_if_can_DI() and DI_timer.is_stopped():
		DI_timer.start()
	
	## y轴重力加速度
	if not is_on_floor(): # 重力加速度
		velocity.y += gravity * delta  # Vy = g * t
	else:
		has_double_jumped = false
	
	## 下面起跑灰尘效果用
	var now_flip_h : bool = sprite.flip_h
	update_facing_directon()
	
	## 可以移动或者可缓慢移动
	if direction.x and (state_machine.check_if_can_move() or state_machine.check_if_decrease_speed()):  # 可以移动或者可缓慢移动的情况下才行
		if state_machine.check_if_decrease_speed():             # 可缓慢移动
			velocity.x = direction.x * speed * 0.23
		else:                                                   # 可移动
			if is_on_floor() and (velocity.x == 0 or now_flip_h != sprite.flip_h):
				on_start_run(sprite.flip_h)  # 起跑时的灰尘效果
			velocity.x = direction.x * speed
			
		if not DI_timer.is_stopped():                           # 进行DI
			velocity.x += direction.x * speed * (DI_timer.wait_time - DI_timer.time_left) * 20
			DI_timer.stop()
	## 不能移动的被击飞状态
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, pp.speed * 0.3 * (100 / (percentage + 10)))
		else:
			velocity.x = move_toward(velocity.x, 0, pp.speed * 0.23 * (100 / (percentage + 10)))
	
	move_and_slide()
	update_animation_parameters()



func update_animation_parameters() -> void:  # 设置移动动画对应参数
	animation_tree.set("parameters/移动/blend_position", direction.x)


func update_facing_directon() -> void:       # 更新面朝方向
	if not state_machine.check_if_can_overturn(): # 检查是否能转向
		return

	if direction.x > 0: # 朝右
		sprite.flip_h = false
		run_start_marker.position.x = -abs(run_start_marker.position.x)

	elif direction.x < 0: # 朝左
		sprite.flip_h = true
		run_start_marker.position.x = abs(run_start_marker.position.x)
		
	emit_signal("facing_direction_changed", !sprite.flip_h) # 发出信号，让剑的碰撞区域也反转


func on_start_run(sprite_flip : bool):       # 起跑时的灰尘效果
	var run_start_effect_instantiate = run_start_effect.instantiate()

	run_start_effect_instantiate.global_position = run_start_marker.global_position
	run_start_effect_instantiate.flip_h = sprite_flip
	run_start_effect_instantiate.scale = Vector2(1.5, 1.5)

	add_sibling(run_start_effect_instantiate)


func check_if_can_DI() -> bool:              # 检查是否能DI
	if velocity.x < -1800 and sprite.flip_h == false and not is_on_floor():
		return true
	elif velocity.x > 1800 and sprite.flip_h == true and not is_on_floor():
		return true
	else:
		return false


func break_skill() -> void:                  # 进入break状态
	has_Break = false
	state_machine.current_state.emit_signal("interrupt_state", pp.break_state)


func SA_state() -> void:                     # 进入无双状态
	SA = true
	trail_timer.start()
	SA_timer.start()
	speed = pp.SA_speed



func DI_timer_init() -> void:
	DI_timer = Timer.new()
	add_child(DI_timer)
	DI_timer.one_shot = true
	DI_timer.wait_time = 0.5

func SA_timer_init() -> void:
	SA_timer = Timer.new()
	add_child(SA_timer)
	SA_timer.one_shot = true
	SA_timer.wait_time = pp.SA_wait_time[scene.mode]

func trail_timer_init() -> void:
	trail_timer.wait_time = 0.05



func ground_state() -> GroundState:
	return pp.ground_default_state
	
func ground_animation() -> String:
	return pp.move_animation
