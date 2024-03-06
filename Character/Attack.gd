extends Area2D

@export var damage : int
@export var player : CharacterBody2D
@export var facing_collision_shape_2d : FacingCollisionShape2D
@export var knockback_speed : float  # 击退速度
@export var angle : float
@export var character_self : CharacterBody2D

func _ready():
	monitoring = false
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)

func _on_body_entered(body): # 剑的碰撞逻辑
	if body == character_self:
		return
	for child in body.get_children():
		if child is Damageable:
			# 击退方向
			var direction_to_damageable = body.global_position - get_parent().global_position
			var knockback_diretion = sign(direction_to_damageable.x) # sign只读方向
			body.velocity = Vector2(knockback_speed * knockback_diretion, -angle * damage)  # 击退
			child.hit(damage)


func _on_player_facing_direction_changed(facing_right : bool):  # 左右改变攻击区域方向
	if facing_right:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_right_position
	else:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_left_position