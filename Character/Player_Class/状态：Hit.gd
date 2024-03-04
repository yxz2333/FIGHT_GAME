extends State

class_name HitState

@export var damageable : Damageable
@export var dead_state : State
@export var dead_animation_node : String = "死亡"
@export var knockback_speed : float = 100.0  # 击退速度
@export var return_state : State

@onready var timer : Timer = $Timer

func _ready():
	damageable.connect("on_hit", _on_damageable_hit)

func on_enter():
	timer.start()
	
func on_exit():
	character.velocity = Vector2.ZERO

func _on_damageable_hit(node : Node, damage_taken : int, knockback_diretion : Vector2):
	if damageable.health > 0:                 # 还活着就接着之前的状态
		character.velocity = knockback_speed * knockback_diretion  # 击退
		emit_signal("interrupt_state", self)
	else:                                     # 死了进入死亡状态
		emit_signal("interrupt_state", dead_state)
		playback.travel(dead_animation_node)


func _on_timer_timeout():
	next_state = return_state
