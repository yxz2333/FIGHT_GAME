extends Control

class_name PlayerSelectMenuUI

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var collision : CollisionShape2D = $Area2D/CollisionShape2D
@onready var marker : Marker2D = $Marker2D
@export var menu : CharacterSelectMenu

var characters = {
	"Marston" : preload("res://Character/MARSTON/marston.tscn"),
	"Namka" : preload("res://Character/NAMKA/namka.tscn"),
	"Musashi" : "",
}

func _ready():
	collision.shape.size = size
	collision.position += size / 2
	marker.position = collision.position


func start():
	pass

func exit():
	pass

func select(player_num : int, input_num) -> void:
	var born_position : Vector2 = marker.global_position
	var char_name : String = name # 所选人物名字
	
	
	var character = characters.get(char_name).instantiate() as Player # 找实例化哪个人物
	character.init(menu, player_num, input_num)
	character.scale = Vector2(1.5, 1.5)
	character.canvas_layer.hide()
	character.global_position = born_position
	menu.add_child(character)
