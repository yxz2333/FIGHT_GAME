extends Area2D


@export var player : CharacterBody2D
@export var facing_collision_shape_2d : FacingCollisionShape2D
@export var character_self : CharacterBody2D
@export var player_property : PlayerProperty

@onready var run_start_marker : Marker2D = $"../Markers/RunStart"

var damage : int
var angle : float
var knockback_speed : float
var camera_shake_offset : Vector2 # 镜头偏移量
var camera_shake_zoom : Vector2 # 镜头缩放
var camera_shake_duration : float
var frame_freeze_duration : float # 卡帧持续时间
var time_scale : float # 卡帧降速


func _ready():
	damage                    =         player_property.damage
	angle                     =         player_property.angle
	knockback_speed           =         player_property.knockback_speed
	camera_shake_offset       =         player_property.camera_shake_offset
	camera_shake_zoom         =         player_property.camera_shake_zoom
	camera_shake_duration     =         player_property.camera_shake_duration
	frame_freeze_duration     =         player_property.frame_freeze_duration
	time_scale                =         player_property.time_scale
	
	monitoring = false
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)

func _on_body_entered(body : Player): # 碰撞逻辑
	if body == character_self:
		return
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage)
			
			# 击退方向
			var direction_to_damageable = body.global_position - run_start_marker.global_position
			var knockback_diretion = sign(direction_to_damageable.x) # sign只读方向
			
			on_opponent_is_hit(knockback_diretion, body)
				

func on_opponent_is_hit(knockback_diretion, opponent : Player):
	## 镜头抖动和卡帧
	CameraSetting.camera_shake(camera_shake_offset, camera_shake_zoom, camera_shake_duration)
	CameraSetting.frame_freeze(time_scale, frame_freeze_duration)
	
	## 击退曲线
	opponent.velocity += Vector2(knockback_diretion * ((damage * opponent.percentage * 0.01 + opponent.percentage * 0.4) * (1000 / (opponent.weight)) * 2.4 + 18) , -damage * opponent.percentage * (200 / (opponent.weight + 100)) * 0.1)

	
func _on_player_facing_direction_changed(facing_right : bool):  # 左右改变攻击区域方向
	if facing_right:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_right_position
	else:
		facing_collision_shape_2d.position = facing_collision_shape_2d.facing_left_position
