extends Node2D

class_name BreakScene

var player : Player
var pp : PlayerProperty

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var timer : Timer = $Timer

@export var damage : float = 10.0

@export var camera_shake_offset = Vector2(10, 0)
@export var camera_shake_zoom = Vector2(0.9, 0.9)
@export var camera_shake_duration = 0.08
@export var time_scale = 0.2
@export var frame_freeze_duration = 0.1


func _ready():
	timer.wait_time = 0.35
	timer.start()
	anim_player.play("break")

func _on_area_2d_body_entered(body : Player):
	if body == player: # 是自己
		return
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage, player)
			var direction : Vector2 = Vector2(body.global_position.x - global_position.x, body.global_position.y - global_position.y)
			on_opponent_is_hit(direction, body)

func on_opponent_is_hit(direction : Vector2, opponent : Player):
	var dir : Vector2 = Vector2(sign(direction.x), sign(direction.y))
	var k   : Vector2 = Vector2(abs(direction.x),  abs(direction.y))
	k.x = 10 if k.x <= 10 else k.x
	k.y = 10 if k.y <= 10 else k.y
	
	opponent.velocity += Vector2 (
		dir.x * 8000 / log(k.x + 1) * (exp(-opponent.percentage / 100) if exp(-opponent.percentage / 100) > 1 else 1), 
		dir.y * 500  / log(k.y + 1) * (exp(-opponent.percentage / 100) if exp(-opponent.percentage / 100) > 1 else 1)
	)
	
	CameraSetting.camera_shake(camera_shake_offset, camera_shake_zoom, camera_shake_duration)
	CameraSetting.frame_freeze(time_scale, frame_freeze_duration)


func _on_timer_timeout():
	queue_free()
