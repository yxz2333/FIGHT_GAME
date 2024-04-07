extends Timer

@export var character : Player

func _on_timeout(): # 时间结束出现新的残影
	if character.velocity == Vector2.ZERO: # 速度为0时肯定没残影了
		return
	
	var trail = preload("res://Character/Class/trail.tscn").instantiate()
	get_parent().add_sibling(trail)
	
	var property = [
		"hframes",
		"vframes",
		"frame",
		"texture",
		"global_position",
		"flip_h",
	] # 根据属性赋值
	
	trail.scale = Vector2(2.0, 2.0)
	trail.z_index = -1
	
	for name in property:
		trail.set(name, character.sprite.get(name))
