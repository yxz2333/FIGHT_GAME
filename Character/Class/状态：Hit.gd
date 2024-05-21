extends State

class_name HitState

@export var damageable : Damageable

@onready var timer : Timer = $Timer

func init():
	damageable.connect("on_hit", _on_damageable_hit)

func on_enter(lambda = null):
	if character.SA:
		能否跑 = true
	
	if lambda != null:
		lambda.call()
	
	## 能跑状态下配置能否跳
	if character.is_on_floor(): # 确保在地面上一定能起跳
		jump_input_cnt = false
	else:                       # 而空中不能再起跳
		jump_input_cnt = true
	
	timer.start()

func _on_damageable_hit(node : Player, damage_taken : int, lambda):
	emit_signal("interrupt_state", self, lambda)
	
	if playback.get_current_node() == pp.hit_animation: # 重置受伤动画
		playback.start(pp.hit_animation)
	else:
		playback.travel(pp.hit_animation)


var jump_input_cnt : bool = false  # 只容许跳一次
func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(pp.jump_action) and jump_input_cnt == false:
		jump()


func jump():
	if 能否跑:
		jump_input_cnt = true
		character.ground_state().jump()


func on_exit():
	能否跑 = false


func _on_timer_timeout():
	_return()
