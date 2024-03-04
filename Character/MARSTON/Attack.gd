extends Area2D

@export var damage : int = 10
@export var player : Player
@export var facing_collision_shape_2d : FacingCollisionShape2D

func _ready():
	monitoring = false
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)

func _on_body_entered(body): # 剑的碰撞逻辑
	for child in body.get_children():
		if child is Damageable:
			# 剑的击退方向
			var direction_to_damageable = body.global_position - get_parent().global_position
			var direction_sign = sign(direction_to_damageable.x) # sign只读方向
			
			if direction_sign > 0:
				child.hit(damage, Vector2.RIGHT)
			elif direction_sign < 0:
				child.hit(damage, Vector2.LEFT)
			else:
				child.hit(damage, Vector2.ZERO)
			
			print_debug(body.name)


func _on_player_facing_direction_changed(facing_right : bool):  # 左右改变攻击区域方向
	if facing_right:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_right_position
	else:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_left_position
