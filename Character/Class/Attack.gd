extends Area2D


@export var player : Player
@export var facing_collision_shape_2d : FacingCollisionShape2D

@onready var run_start_marker : Marker2D = $"../Markers/RunStart"

var damage : int
var knockback_speed : float
var camera_shake_offset : Vector2 # 镜头偏移量
var camera_shake_zoom : Vector2 # 镜头缩放
var camera_shake_duration : float
var frame_freeze_duration : float # 卡帧持续时间
var time_scale : float # 卡帧降速
var extra_knockback_speed : float # 额外可调节击退速度


func _ready():
	damage                    =         player.pp.damage
	knockback_speed           =         player.pp.base_knockback_speed
	extra_knockback_speed     =         player.pp.extra_knockback_speed
	camera_shake_offset       =         player.pp.camera_shake_offset
	camera_shake_zoom         =         player.pp.camera_shake_zoom
	camera_shake_duration     =         player.pp.camera_shake_duration
	frame_freeze_duration     =         player.pp.frame_freeze_duration
	time_scale                =         player.pp.time_scale
	
	monitoring = false
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)

func _on_body_entered(body : Player): # 碰撞逻辑
	if body == player:
		return
	for child in body.get_children():
		if child is Damageable and not body.state_machine.check_if_cannot_hurt():
			child.hit(damage, player)
			
			# 击退方向
			var direction_to_damageable = body.global_position - run_start_marker.global_position
			var knockback_direction = sign(direction_to_damageable.x)
			
			on_opponent_is_hit(knockback_direction, body)


func on_opponent_is_hit(knockback_direction, opponent : Player):
	
	## 镜头抖动和卡帧
	CameraSetting.camera_shake(camera_shake_offset, camera_shake_zoom, camera_shake_duration)
	CameraSetting.frame_freeze(time_scale, frame_freeze_duration)
	
	## 击退曲线
	opponent.velocity += Vector2(knockback_direction * ((damage * opponent.percentage * 0.01 + opponent.percentage * 0.4) * (1000 / (opponent.pp.weight)) * 2.4 + knockback_speed * ((100 - opponent.percentage) if 100 - opponent.percentage > 20 else 20) + extra_knockback_speed) , -damage * opponent.percentage * (200 / (opponent.pp.weight + 100)) * 0.1)

	
func _on_player_facing_direction_changed(facing_right : bool):  # 左右改变攻击区域方向
	if facing_right:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_right_position
	else:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_left_position
