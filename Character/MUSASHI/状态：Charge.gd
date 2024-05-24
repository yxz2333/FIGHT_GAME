extends State

class_name ChargeState


@onready var timer : Timer = $Timer
@onready var auto_timer : Timer = $AutoTimer

var jump_input_cnt : bool = false # 只容许跳一次
var early_exit : bool = false
var repid : PackedScene = preload("res://Character/Class/Repid.tscn")


func init():
	super()
	timer.wait_time = character.pp.charge_time[character.scene.mode]
	auto_timer.wait_time = 0.3
	timer.one_shot = true

func on_enter(lambda = null):
	auto_timer.start()
	
	timer.start()      # 重置timer
	timer.stop()
	early_exit = false # 防止多次结束
	
	if character.is_on_floor(): # 确保在地面上一定能起跳攻击
		jump_input_cnt = false
	else:                       # 而空中不能再起跳攻击
		jump_input_cnt = true


func on_exit() -> void:
	early_exit = true
	timer.start()      # 重置timer
	timer.stop()


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(pp.jump_action) and jump_input_cnt == false and 能否跳:
		jump()

func state_process(delta) -> void:
	super(delta)
	if early_exit:
		return
	
	if Input.is_action_just_released(character.pp.attack_action):
		if not auto_timer.is_stopped(): # 不是长按就闪
			early_exit = true
			set_next_state(character.pp.flash_state)
		else:
			cal()
			set_next_state(character.pp.attack_state)
		return
	
	if Input.is_action_pressed(character.pp.attack_action) and not auto_timer.is_stopped():
		if timer.is_stopped():
			timer.start()
			playback.travel(pp.charge_animation)


func _on_timer_timeout(): # 蓄完力自动攻击
	if not auto_timer.is_stopped() or early_exit:
		return
	cal()
	set_next_state(character.pp.attack_state)


func jump() -> void: # 连跳
	jump_input_cnt = true
	character.velocity.y = pp.jump_velocity


func cal() -> void:
	early_exit = true
	var cha : float = (character.pp.charge_time[character.scene.mode] - timer.time_left) / timer.wait_time
	pp.damage = cha * pp.base["damage"]
	
	## 配置不同模式下的击退
	if character.scene.mode == "party":
		if character.scene.game_manager.number > 2:
			pp.base_knockback_speed = cha * pp.base["party"]["1v1v1"].x
			pp.extra_knockback_speed = cha * pp.base["party"]["1v1v1"].y
		else:
			pp.base_knockback_speed = cha * pp.base["party"]["1v1"].x
			pp.extra_knockback_speed = cha * pp.base["party"]["1v1"].y
	else:
		pp.base_knockback_speed = cha * pp.base["base_knockback_speed"]
		pp.extra_knockback_speed = cha * pp.base["extra_knockback_speed"]
		
	pp.camera_shake_duration = cha * pp.base["camera_shake_duration"]
	pp.frame_freeze_duration = cha * pp.base["frame_freeze_duration"]
