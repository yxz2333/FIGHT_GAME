extends State

class_name HitState

@export var damageable : Damageable

@onready var timer : Timer = $Timer

func init():
	damageable.connect("on_hit", _on_damageable_hit)

func on_enter(lamda = null):
	if character.SA:
		能否跑 = true
	
	if lamda != null:
		lamda.call()
	
	timer.start()

func _on_damageable_hit(node : Player, damage_taken : int, lamda):
	emit_signal("interrupt_state", self, lamda)
	
	if playback.get_current_node() == pp.hit_animation: # 重置受伤动画
		playback.start(pp.hit_animation)
	else:
		playback.travel(pp.hit_animation)

func _on_timer_timeout():
	next_state = character.current_ground_state
	playback.travel(character.current_ground_animation)

func on_exit():
	能否跑 = false
