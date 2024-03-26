extends Node

## 编写可受伤属性
class_name Damageable

signal on_hit(node : Node, damage_taken : int, knockback_diretion : Vector2)

@export var dead_animation_name : String = "死亡"
@export var character : CharacterBody2D
@export var player_property : PlayerProperty

func hit(damage : int): # 扣血、闪白
	character.health -= damage
	character.weight = float(character.health) / player_property.original_health * player_property.original_weight + 20.0 # 人物体重变化

	emit_signal("on_hit", get_parent(), damage)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == dead_animation_name:
		get_parent().queue_free()
