extends Label

@export var float_speed : Vector2 = Vector2(0, -50)  # 文字向上浮动的速度变量

func _process(delta):
	position += float_speed * delta


func _on_timer_timeout():
	queue_free()    # 伤害显示过一段时间消失
