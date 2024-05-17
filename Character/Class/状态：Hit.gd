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
	
	timer.start()

func _on_damageable_hit(node : Player, damage_taken : int, lambda):
	emit_signal("interrupt_state", self, lambda)
	
	if playback.get_current_node() == pp.hit_animation: # 重置受伤动画
		playback.start(pp.hit_animation)
	else:
		playback.travel(pp.hit_animation)

func _on_timer_timeout():
	_return()

func on_exit():
	能否跑 = false
