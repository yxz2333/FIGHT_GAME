extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var label : Label = $Label
@export var game_manager : GameManager
var is_game_over : bool = false

func _ready():
	hide()
	game_manager.connect("who_is_winner", _on_who_is_winner)


func _on_who_is_winner(winner : Player) -> void:
	var num = winner.pp.player_number
	if game_manager.mode == "party":
		game_manager.scene.phantom_camera.erase_follow_targets(winner)
	winner.queue_free()
	
	if game_manager.mode == "party":
		get_tree().root.set_content_scale_factor(2)
	
	label.hide()
	show()
	await get_tree().create_timer(1.5).timeout
	
	label.text = ("Player" + ' ' + str(num))
	
	animation_player.play("GG")
	
	await get_tree().create_timer(0.5).timeout
	is_game_over = true


var cnt : int = 1
func _input(event):
	if (event is InputEventKey or event is InputEventJoypadButton) and is_game_over and cnt:
		cnt -= 1
		get_tree().paused = false
		Transitions.tran_d_0_without_loading("res://UI/mode_select.tscn")
