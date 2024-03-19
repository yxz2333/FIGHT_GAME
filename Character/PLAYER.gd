extends CharacterBody2D

class_name Player

@export var left_action : String
@export var right_action : String
@export var up_action : String
@export var down_action : String

@export var scene : Scene
@onready var player_property : PlayerProperty = $PlayerProperty
@onready var sprite : Sprite2D = $Sprite2D 
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

var speed : float
var weight : float
var health : float :
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_health_changed", self, value - health) # 发出扣了多少血的信号
		health = value
		SignalBus.emit_signal("health_bar_change") # 血条变化


var direction : Vector2 = Vector2.ZERO # 读入键盘手柄输入用
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # 获取项目设置里设置的重力大小

signal facing_direction_changed(facing_right : bool)


func _ready():
	weight = player_property.original_weight
	health = player_property.original_health
	speed = player_property.speed
	animation_tree.active = true

func _physics_process(delta): 
	direction = Input.get_vector(left_action, right_action, up_action, down_action) # 读入x轴和y轴输入	
	
	if not is_on_floor(): # 重力加速度
		velocity.y += gravity * delta  # Vy = g * t 

	var now_flip_h : bool = sprite.flip_h
	update_facing_directon()

	if direction.x and state_machine.check_if_can_move(): 
		if is_on_floor() and (velocity.x == 0 or now_flip_h != sprite.flip_h):
			scene.on_start_run(self, sprite.flip_h)  # 起跑时的灰尘效果
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * weight / 500)
	
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
	elif direction.x < 0: # 朝左
		sprite.flip_h = true
		
	emit_signal("facing_direction_changed", !sprite.flip_h) # 发出信号，让剑的碰撞区域也反转

