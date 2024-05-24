extends State

class_name DefenseState

var is_bullet_angry_recovered : bool = false

func on_enter(lambda = null):
	playback.travel("防御")
	pp.feet_label.set_short_text("DEFENSE")
	is_bullet_angry_recovered = false


func counter_attack(by_who : Player) -> void:      # 给近战用的接口
	by_who.state_machine.current_state.能否输入 = false
	emit_signal("interrupt_state", pp.counter_attack_state, func() -> Player:
		return by_who)


func bulled_flip(bullet : Bullet) -> void:         # 给飞行道具用的接口
	bullet.rotation_degrees = 180.0
	bullet.direction *= -1
	bullet.player = character
	if not is_bullet_angry_recovered:   # 只回复一次怒气值
		character.angry += 15
		is_bullet_angry_recovered = true


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == pp.defense_animation:
		_return()
