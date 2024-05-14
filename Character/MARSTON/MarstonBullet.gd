extends Bullet


func _on_body_entered(body : Player): # 碰撞逻辑
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage, player, 
			## lambda函数
			func() -> void:
				body.state_machine.current_state.能否跑 = true
			)
			queue_free()
