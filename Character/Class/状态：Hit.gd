extends State

class_name HitState

@export var damageable : Damageable
@export var hit_animation : String

@onready var timer : Timer = $Timer

func _ready():
	damageable.connect("on_hit", _on_damageable_hit)

func on_enter():
	timer.start()

func _on_damageable_hit(node : Player, damage_taken : int):
	emit_signal("interrupt_state", self)
	print("{a}:{b}".format({"a" : node.name , "b" : node.percentage}))
	
	if playback.get_current_node() == hit_animation: # 重置受伤动画
		playback.start(hit_animation)
	else:
		playback.travel(hit_animation)

func _on_timer_timeout():
	next_state = return_to_ground_state
	playback.travel(return_to_ground_animaton)
