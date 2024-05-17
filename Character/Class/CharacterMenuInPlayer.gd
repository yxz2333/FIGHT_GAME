extends CanvasLayer

class_name CharacterMenuInPlayer

@export var menu : Array[CharacterMenu]

@export var character : Player

var collision : PackedScene = preload("res://Character/Class/character_menu_area_2d.tscn") 

var menu_pos : Array[Vector2] = []
var menu_coll_pos : Array[Vector2] = []

func _ready():
	if character.scene.mode == "character_select":
		return
		
	if character.scene.mode == "solo":
		menu_pos.append_array([Vector2(10, 8), Vector2(485, 8)])
		menu_coll_pos.append_array([Vector2(-237, -150), Vector2(239, -150)])
		
	if character.scene.mode == "party":
		pass
	
	for i in len(menu):
		menu[i].global_position = menu_pos[i]
		
		var coll_instance = collision.instantiate()
		coll_instance.name = str("character_menu_area_2d" + str(i))
		coll_instance.global_position = menu_coll_pos[i]
		coll_instance.connect("body_entered", menu[i]._on_area_2d_body_entered)
		coll_instance.connect("body_exited", menu[i]._on_area_2d_body_exited)
		character.add_sibling.call_deferred(coll_instance)  # 延迟加节点
