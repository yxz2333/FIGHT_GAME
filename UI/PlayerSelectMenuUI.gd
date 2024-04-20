extends Control

class_name PlayerSelectMenuUI

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var collision : CollisionShape2D = $Area2D/CollisionShape2D
@onready var marker : Marker2D = $Marker2D
@export var menu : CharacterSelectMenu

var characters = {
	"Marston" : preload("res://Character/MARSTON/marston.tscn"),
	"Namka" : preload("res://Character/NAMKA/namka_angry_bar.tscn"),
	"Musashi" : "",
}

func _ready():
	collision.shape.size = size
	collision.position += size / 2
	marker.position = collision.position

func start():
	print_debug(name)

func exit():
	pass

func select(player_num : int) -> void:
	var born_position : Vector2 = marker.position
	var char_name : String = name # 所选人物名字
	
	var character = characters.get(char_name).instantiate() as Player
	character.global_position = born_position
	character.pp.player_number = player_num
	character.scene = menu
	menu.add_child(character)
