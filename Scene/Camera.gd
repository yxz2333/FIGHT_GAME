extends Camera2D


func camera_shake(_offset, _scale):
	var tween = create_tween() # 处理动画帧
	tween.tween_property(self, "offset", Vector2.ZERO, 0.12).from(_offset) # offset变化，从_offset到
	tween.parallel().tween_property(self, "zoom", Vector2(1.00,1.00), 0.12).from(_scale) # 与上一个语句并行


func frame_freeze(time_scale, duration):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1

