extends Bullet


func _on_body_entered(body : Player): # 碰撞逻辑
	if handle_bullet_flip(body): # 被当身
		return
		
	if check_if_myself(body) or body.state_machine.check_if_cannot_hurt():
		return
		
	for child in body.get_children():
		if child is Damageable:
			if is_instance_valid(player):  # 释放的对象不能传入函数
				player = null
				
			child.hit(damage, player, 
			## lambda函数
			func() -> void:
				body.state_machine.current_state.能否跑 = true
			)
			queue_free()
