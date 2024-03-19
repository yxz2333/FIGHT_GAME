extends State

class_name HitState

@export var damageable : Damageable
@export var dead_state : State
@export var hit_animation : String

@onready var timer : Timer = $Timer

func _ready():
	damageable.connect("on_hit", _on_damageable_hit)

func on_enter():
	timer.start()
	
func on_exit(): # 可以改改
	character.velocity = Vector2.ZERO
	

func _on_damageable_hit(node : CharacterBody2D, damage_taken : int):
	if node.health > 0:                 # 还活着就接着之前的状态
		if playback.get_current_node() == hit_animation: # 重置受伤动画
			playback.start(hit_animation)
		else:
			playback.travel(hit_animation)
		emit_signal("interrupt_state", self)
	else:                                     # 死了进入死亡状态
		emit_signal("interrupt_state", dead_state)

func _on_timer_timeout():
	next_state = return_to_ground_state
	playback.travel(return_to_ground_animaton)
