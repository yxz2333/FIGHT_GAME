extends Node2D

class_name FeetLabel

# @export var mark : Marker2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer

func set_short_text(text : String) -> void:
	# position = mark.position
	var am : Animation = anim_player.get_animation("short")
	am.track_set_key_value(0, 0, text)
	anim_player.stop()
	anim_player.play("short")

func set_long_text(text : String) -> void:
	# position = mark.position
	var am : Animation = anim_player.get_animation("long")
	am.track_set_key_value(0, 0, text)
	anim_player.stop()
	anim_player.play("long")
