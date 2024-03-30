extends Timer

@export var character : Player

func _on_timeout(): # 出现新的残影
	if character.velocity == Vector2.ZERO:
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
	]
	
	trail.scale = Vector2(2.0, 2.0)
	
	for name in property:
		trail.set(name, character.sprite.get(name))
