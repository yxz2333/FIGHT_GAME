extends State

class_name HitState

@export var damageable : Damageable

@onready var timer : Timer = $Timer

func init():
	damageable.connect("on_hit", _on_damageable_hit)

func on_enter():
	timer.start()

func _on_damageable_hit(node : Player, damage_taken : int):
	emit_signal("interrupt_state", self)
	print("{a}:{b}".format({"a" : node.name , "b" : node.percentage}))
	
	if playback.get_current_node() == pp.hit_animation: # 重置受伤动画
		playback.start(pp.hit_animation)
	else:
		playback.travel(pp.hit_animation)

func _on_timer_timeout():
	next_state = return_to_ground_state
	playback.travel(return_to_ground_animaton)
