extends Area2D

class_name Attack

@export var player : Player
@export var facing_collision_shape_2d : FacingCollisionShape2D

@onready var run_start_marker : Marker2D = $"../Markers/RunStart"


func _ready():
	monitoring = false
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)

func handle_defense(body : Player) -> bool:
	if body.state_machine.current_state is DefenseState:
		body.state_machine.current_state.counter_attack(player)
		return true
	return false

func _on_body_entered(body : Player): # 碰撞逻辑
	if handle_defense(body): # 被当身
		return
	
	if body == player or body.state_machine.check_if_cannot_hurt():
		return
	
	for child in body.get_children():
		if child is Damageable:
			child.hit(player.pp.damage, player)
			
			# 击退方向
			var direction_to_damageable = body.global_position - run_start_marker.global_position
			var knockback_direction = sign(direction_to_damageable.x)
			
			if not body.SA:
				on_opponent_is_hit(knockback_direction, body)


func on_opponent_is_hit(knockback_direction, opponent : Player):
	
	## 镜头抖动和卡帧
	player.camera_setting.camera_shake(player.pp.camera_shake_offset, player.pp.camera_shake_zoom, player.pp.camera_shake_duration)
	player.camera_setting.frame_freeze(player.pp.time_scale, player.pp.frame_freeze_duration)
	
	## 击退曲线
	opponent.velocity += Vector2(knockback_direction * ((player.pp.damage * opponent.percentage * 0.01 + opponent.percentage * 0.4) * (1000 / (opponent.pp.weight)) * 2.4 + player.pp.base_knockback_speed * ((100 - opponent.percentage) if 100 - opponent.percentage > 20 else 20) + player.pp.extra_knockback_speed) , 
								 -player.pp.damage * opponent.percentage * (200 / (opponent.pp.weight + 100)) * 0.1)

	
func _on_player_facing_direction_changed(facing_right : bool):  # 左右改变攻击区域方向
	if facing_right:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_right_position
	else:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_left_position
