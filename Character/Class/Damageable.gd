extends Node

## 编写可受伤属性
class_name Damageable

signal on_hit(node : Node, damage_taken : int, lambda)

@export var dead_animation_name : String = "死亡"
@export var character : Player
@export var player_property : PlayerProperty

func hit(damage : int, by_who : Player, lambda = null): # 计算百分比、怒气值、闪白
	by_who.angry += damage * 0.25
	character.percentage += damage * 0.25
	character.angry += damage * 0.5
	emit_signal("on_hit", get_parent(), damage, lambda)
