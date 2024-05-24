extends AttackState

var repid : PackedScene = preload("res://Character/Class/Repid.tscn") # 到时候找时间封装一下这里

func state_input(event : InputEvent) -> void:
	super(event)
	if event.is_action_pressed(pp.special_2_action) and character.angry >= 15:
		attack_area.monitoring = false
		pp.feet_label.set_short_text("REPID")
		var repid_instance = repid.instantiate()
		character.angry -= 15
		repid_instance.global_position = character.global_position
		add_child(repid_instance)
		_return()


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == pp.attack_1_animation_left or anim_name == pp.attack_1_animation_right:
		能否跑 = false
		能否跳 = false
		playback.travel(pp.attack_2_animation_origin)
	if anim_name == pp.attack_2_animation_left or anim_name == pp.attack_2_animation_right:
		_return()
