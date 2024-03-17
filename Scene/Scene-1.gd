extends Node2D

class_name Scene

@export var tilemap_limit_left : float = -340.0
@export var tilemap_limit_right : float = 340.0

@export var run_start_effect : PackedScene

func on_start_run(player : Player, sprite_flip : bool): # 起跑时的灰尘效果
	var run_start_effect_instantiate = run_start_effect.instantiate()
	run_start_effect_instantiate.position = Vector2(player.position.x + player.player_property.run_start_position.x , player.position.y + player.player_property.run_start_position.y)
	run_start_effect_instantiate.flip_h = sprite_flip
	run_start_effect_instantiate.scale = Vector2(1.5, 1.5)
	add_child(run_start_effect_instantiate)
