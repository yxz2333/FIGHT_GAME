extends CharacterBody2D

class_name NAMKA

@export var speed : float = 200.0
@export var original_weight : float
var weight : float
@export var original_health : float
var health : float :
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_health_changed", self, value - health) # 发出扣了多少血的信号
		health = value

@onready var sprite : Sprite2D = $Sprite2D 
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

var direction : Vector2 = Vector2.ZERO # 读入键盘手柄输入用
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # 获取项目设置里设置的重力大小

signal facing_direction_changed(facing_right : bool)

func _ready():
	weight = original_weight
	health = original_health
	animation_tree.active = true

func _physics_process(delta): 
	
	direction = Input.get_vector("left_player_2", "right_player_2", "up_player_2", "down_player_2") # 读入x轴和y轴输入	
	
	if not is_on_floor(): # 重力加速度
		velocity.y += gravity * delta  # Vy = g * t 
	
	if is_on_floor() and direction.y > 0: # 单向台阶下落
		position.y += 1
	
	if direction.x and state_machine.check_if_can_move(): 
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * weight / 500)
	
	move_and_slide()
	update_animation_parameters()
	update_facing_directon()
	
func is_still() -> bool:
	return is_zero_approx(direction.x) and is_zero_approx(velocity.x)

var check : float = 1.0
func update_animation_parameters() -> void: # 设置移动动画对应参数
	animation_tree.set("parameters/移动/blend_position", direction.x)
	animation_tree.set("parameters/攻击_准备/blend_position", check)
	animation_tree.set("parameters/攻击/blend_position", check)

func update_facing_directon() -> void: # 更新面朝方向
	if not state_machine.check_if_can_overturn(): # 检查是否能转向
		return
	if direction.x > 0: # 朝右
		check = 1.0
		sprite.flip_h = false
	elif direction.x < 0: # 朝左
		check = -1.0
		sprite.flip_h = true
		
	emit_signal("facing_direction_changed", !sprite.flip_h) # 发出信号，让剑的碰撞区域也反转
