extends CharacterBody2D

class_name Player


@export var run_start_effect : PackedScene
@export var scene : Scene
@export var pp : PlayerProperty
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var run_start_marker : Marker2D = $Markers/RunStart

var direction : Vector2 = Vector2.ZERO # 读入键盘手柄输入用
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # 获取项目设置里设置的重力大小
signal facing_direction_changed(facing_right : bool)
var DI_timer : Timer

var percentage : float = 0.0
var angry : int :
	get:
		return angry
	set(value):
		if value >= 100:
			value = 100
		for key in pp.player_signal.keys(): # 找和玩家编号匹配的信号进行发送
			if key == pp.player_number:
				SignalBus.emit_signal(pp.player_signal[key])
		angry = value


func _ready():
	animation_tree.active = true
	DI_timer = Timer.new()
	add_child(DI_timer)
	DI_timer.one_shot = true
	DI_timer.wait_time = 0.5


func _physics_process(delta):
	direction = Input.get_vector(pp.left_action, pp.right_action, pp.up_action, pp.down_action) # 读入x轴和y轴输入
	
	if Input.is_action_pressed(pp.break_action) and state_machine.current_state != pp.break_state and pp.break_state.if_can_break():
		break_skill()
	
	if check_if_can_DI() and DI_timer.is_stopped():
		DI_timer.start()
	
	if not is_on_floor(): # 重力加速度
		velocity.y += gravity * delta  # Vy = g * t

	var now_flip_h : bool = sprite.flip_h
	update_facing_directon()

	if direction.x and state_machine.check_if_can_move():
		if state_machine.current_state is AttackState: # Attack状态缓慢移动
			velocity.x = direction.x * pp.speed * 0.1
		else:                                          # Ground状态移动
			if is_on_floor() and (velocity.x == 0 or now_flip_h != sprite.flip_h) and state_machine.current_state is GroundState:
				on_start_run(sprite.flip_h)  # 起跑时的灰尘效果
			velocity.x = direction.x * pp.speed
	
		if not DI_timer.is_stopped():
			velocity.x += direction.x * pp.speed * (DI_timer.wait_time - DI_timer.time_left) * 20
			DI_timer.stop()
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, pp.speed * 0.3 * (100 / (percentage + 10)))
		else:
			velocity.x = move_toward(velocity.x, 0, pp.speed * 0.23 * (100 / (percentage + 10)))
	
	
	
	check_if_out_of_screen()
	move_and_slide()
	update_animation_parameters()



func check_if_out_of_screen():               # 检查是否飞出屏幕
	if position.x < scene.tilemap_limit_left or position.x > scene.tilemap_limit_right: # 出屏幕
		SignalBus.emit_signal("player_out_of_screen", self)
		
		for child in get_children(): # 先删了材质，防止穿帮
			if child is AnimationPlayer:
				child.queue_free()
				break


func update_animation_parameters() -> void:  # 设置移动动画对应参数
	pass


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


func break_skill() -> void:
	state_machine.current_state.emit_signal("interrupt_state", pp.break_state)
