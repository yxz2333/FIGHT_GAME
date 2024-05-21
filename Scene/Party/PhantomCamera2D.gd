extends PhantomCamera2D

class_name PhantomCameraSetting

var FF : bool = true

func camera_shake(_offset, _scale, duration):
	if FF:
		var tween = create_tween() # 处理动画帧
		tween.tween_property(self, "follow_offset", Vector2.ZERO, duration).from(_offset) # offset变化，从_offset到
		#tween.parallel().tween_property(self, "zoom", Vector2(1.00, 1.00), duration).from(_scale) # 与上一个语句并行


func frame_freeze(time_scale, duration):
	if FF:
		Engine.time_scale = time_scale
		await get_tree().create_timer(duration, true, false, true).timeout
		Engine.time_scale = 1
