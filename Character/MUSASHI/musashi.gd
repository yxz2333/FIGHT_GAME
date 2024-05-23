extends Player

var anim : Animation


func init(s : Scene, pn : int, input_c):
	super(s, pn, input_c)
	anim = anim_player.get_animation("斩")


func update_facing_directon() -> void:       # 更新面朝方向
	super()
	## 改变斩动画的碰撞体位置
	if not sprite.flip_h: # 朝右
		anim.track_set_key_value(4, 1, Vector2(12, -0.5))
	else:
		anim.track_set_key_value(4, 1, Vector2(-12, -0.5))
