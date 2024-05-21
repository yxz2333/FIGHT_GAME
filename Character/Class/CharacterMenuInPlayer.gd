extends CanvasLayer

class_name CharacterMenuInPlayer

@export var character : Player

## 左右MenuUI
var cleft : PackedScene
var cright : PackedScene

var collision : PackedScene = preload("res://Character/Class/character_menu_area_2d.tscn") 
const coll_pos : Array[Vector2] = [Vector2(-237, -150), Vector2(239, -150)] # 0 : 左， 1 : 右


var menu  # CharacterMenuUI

func _ready():
	if character.scene.mode == "character_select":
		return
	
	cleft = character.game_manager.character_menu
	cright = character.game_manager.character_menu_right
	
	if character.scene.mode == "solo":
		_solo()
		
	if character.scene.mode == "party":
		_party()


func _solo() -> void:
	## 实例化 Menu
	if character.pp.player_number == 1:
		menu = cleft.instantiate()
	else:
		menu = cright.instantiate()
	menu.p_label = character.P_label
	menu.character = character
	menu.num = character.pp.player_number
	
	## 实例化碰撞
	var coll_instance = collision.instantiate()
	coll_instance.global_position = coll_pos[menu.num - 1]
	coll_instance.body_entered.connect(menu._on_area_2d_body_entered)
	coll_instance.body_exited.connect(menu._on_area_2d_body_exited)
	add_child(menu)
	character.add_sibling.call_deferred(coll_instance)  # 延迟加节点



func _party() -> void:
	## 实例化 Menu
	menu = cleft.instantiate()
	menu.p_label = character.P_label
	menu.character = character
	menu.num = character.pp.player_number
	add_child(menu)
