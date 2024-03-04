extends Node

## 编写可受伤属性
class_name Damageable

signal on_hit(node : Node, damage_taken : int, knockback_diretion : Vector2)

@export var dead_animation_name : String = "死亡"
@export var health : float = 20 :
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_health_changed", get_parent(), value - health) # 发出Snail扣了多少血的信号
		health = value

func hit(damage : int, knockback_diretion : Vector2):
	health -= damage
	
	emit_signal("on_hit", get_parent(), damage, knockback_diretion)
	

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == dead_animation_name:
		get_parent().queue_free()
