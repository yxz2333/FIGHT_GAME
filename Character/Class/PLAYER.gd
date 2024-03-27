extends CharacterBody2D

class_name Player


@export var run_start_effect : PackedScene

@export var scene : Scene
@onready var player_property : PlayerProperty = $PlayerProperty
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var run_start_marker : Marker2D = $Markers/RunStart

var left_action : String
var right_action : String
var up_action : String
var down_action : String


var percentage : float = 0.1

#var health : float :
	#get:
		#return health
	#set(value):
		#if value <= 0 and last_chance == false:
			#last_chance = true
			#value = 1
		#SignalBus.emit_signal("on_health_changed", self, value - health) # 发出扣了多少血的信号
		#health = value
		#SignalBus.emit_signal("health_bar_change") # 血条变化

var direction : Vector2 = Vector2.ZERO # 读入键盘手柄输入用
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # 获取项目设置里设置的重力大小

signal facing_direction_changed(facing_right : bool)

var DI_timer : Timer

var speed : float
var weight : float

func _ready():
	left_action = player_property.left_action
	right_action = player_property.right_action
	up_action = player_property.up_action
	down_action = player_property.down_action
	weight = player_property.weight
	#health = player_property.original_health
	speed = player_property.speed
	animation_tree.active = true
	DI_timer = Timer.new()
	add_child(DI_timer)
	DI_timer.one_shot = true
	DI_timer.wait_time = 0.5

func _physics_process(delta):
	direction = Input.get_vector(left_action, right_action, up_action, down_action) # 读入x轴和y轴输入
	#print(velocity.x)
	if check_if_can_DI() and DI_timer.is_stopped():
		DI_timer.start()
	
	if not is_on_floor(): # 重力加速度
		velocity.y += gravity * delta  # Vy = g * t

	var now_flip_h : bool = sprite.flip_h
	update_facing_directon()

	if direction.x and state_machine.check_if_can_move():
		if is_on_floor() and (velocity.x == 0 or now_flip_h != sprite.flip_h):
			on_start_run(sprite.flip_h)  # 起跑时的灰尘效果
		velocity.x = direction.x * speed
	
		if not DI_timer.is_stopped():
			print(-1)
			velocity.x += direction.x * speed * (DI_timer.wait_time - DI_timer.time_left) * 40
			DI_timer.stop()
			
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 0.2 * (100 / percentage))
	
	
	
	check_if_out_of_screen()
	move_and_slide()
	update_animation_parameters()



func check_if_out_of_screen():
	if position.x < scene.tilemap_limit_left or position.x > scene.tilemap_limit_right: # 出屏幕
		SignalBus.emit_signal("player_out_of_screen", self)


func update_animation_parameters() -> void: # 设置移动动画对应参数
	pass


func update_facing_directon() -> void: # 更新面朝方向
	if not state_machine.check_if_can_overturn(): # 检查是否能转向
		return

	if direction.x > 0: # 朝右
		sprite.flip_h = false
		run_start_marker.position.x = -abs(run_start_marker.position.x)

	elif direction.x < 0: # 朝左
		sprite.flip_h = true
		run_start_marker.position.x = abs(run_start_marker.position.x)
		
	emit_signal("facing_direction_changed", !sprite.flip_h) # 发出信号，让剑的碰撞区域也反转


func on_start_run(sprite_flip : bool): # 起跑时的灰尘效果
	
	var run_start_effect_instantiate = run_start_effect.instantiate()

	run_start_effect_instantiate.global_position = run_start_marker.global_position
	run_start_effect_instantiate.flip_h = sprite_flip
	run_start_effect_instantiate.scale = Vector2(1.5, 1.5)

	add_sibling(run_start_effect_instantiate)


func check_if_can_DI() -> bool:
	if velocity.x < -1600 and sprite.flip_h == false and not is_on_floor():
		return true
	elif velocity.x > 1600 and sprite.flip_h == true and not is_on_floor():
		return true
	else:
		return false
