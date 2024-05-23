extends State

var FB : PackedScene = preload("res://Character/MUSASHI/flash_back.tscn")

func on_enter(lambda = null) -> void:
	## 原地释放碰撞检测是否恰好闪避攻击
	var flash_back = FB.instantiate()
	flash_back.init(character)
	flash_back.global_position = character.global_position
	add_sibling(flash_back)
	
	var anim : Animation = character.anim_player.get_animation("闪避")
	## 人物加速
	if character.sprite.flip_h == true: # 左
		anim.track_set_key_value(6, 0, character.global_position)
		anim.track_set_key_value(6, 1, character.global_position - character.pp.dash)
	else: # 右
		anim.track_set_key_value(6, 0, character.global_position)
		anim.track_set_key_value(6, 1, character.global_position + character.pp.dash)
	
	playback.travel(pp.flash_animation)

func _on_flash_end() -> void:
	set_next_state(pp.flash_end_state)
