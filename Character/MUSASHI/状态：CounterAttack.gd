extends State

class_name CounterAttackState

var by_who : Player
var damage_able : Damageable

func on_enter(lambda = null):
	playback.travel(pp.counter_attack_1_animation)
	by_who = lambda.call()
	for child in by_who.get_children():
		if child is Damageable:
			damage_able = child
			break
	damage_able.hit(pp.counter_attack_damage, character) # 单纯使用hit无击退
	await get_tree().create_timer(0.2).timeout # 等待0.25秒
	damage_able.hit(pp.counter_attack_damage, character)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == pp.counter_attack_1_animation:
		playback.travel(pp.counter_attack_2_animation)
		damage_able.hit(pp.counter_attack_damage, character)
		await get_tree().create_timer(0.2).timeout # 等待0.25秒
		damage_able.hit(pp.counter_attack_damage, character)
		
	if anim_name == pp.counter_attack_2_animation:
		by_who.state_machine.current_state.能否输入 = true
		_return()
