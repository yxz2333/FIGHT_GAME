extends ShotState

@export var shot_freeze_timer : Timer

func init():
	super() # 调用父节点
	shot_freeze_timer.wait_time = pp.bullet_freeze_time

func on_enter(lambda = null) -> void:
	if not shot_freeze_timer.is_stopped():  # 还在冷却直接返回
		_return()
		return
	
	super() # 调用父节点的子弹发射坐标翻转函数
	shot()
	shot_freeze_timer.start()
	playback.travel(pp.shot_animation)
	
func shot() -> void:
	var bullet_instantiate = bullet.instantiate()
	bullet_instantiate.player = player
	bullet_instantiate.player_property = pp
	bullet_instantiate.global_position = bullet_start_marker.global_position
	player.add_sibling(bullet_instantiate)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == pp.shot_animation:
		_return()
