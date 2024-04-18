extends Node2D

class_name PlayerSelectMenuUI

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@export var menu : CharacterSelectMenu
@export var charactor : PackedScene


func start():
	pass

func exit():
	pass

func select(player_num : int):
	var character_instantiate = charactor.instantiate()
	character_instantiate.global_position = menu.player_markers[player_num].position
	menu.add_child(character_instantiate)
