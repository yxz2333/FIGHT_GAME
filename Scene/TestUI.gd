extends Window

class_name LevelTestUI

@export var game_manager : GameManager
@export var scene : Scene

@onready var VB = [
	{
		"label" : $PanelContainer/Main/VBoxContainer0/Label,
		"percentage" : $PanelContainer/Main/VBoxContainer0/Percentage/Percentage0,
		"angry" : $PanelContainer/Main/VBoxContainer0/Angry/Angry0
	},
	{
		"label" : $PanelContainer/Main/VBoxContainer1/Label,
		"percentage" : $PanelContainer/Main/VBoxContainer1/Percentage/Percentage1,
		"angry" : $PanelContainer/Main/VBoxContainer1/Angry/Angry1
	},
	{
		"label" : $PanelContainer/Main/VBoxContainer2/Label,
		"percentage" : $PanelContainer/Main/VBoxContainer2/Percentage/Percentage2,
		"angry" : $PanelContainer/Main/VBoxContainer2/Angry/Angry2
	},
]

var who : Array[Player] = []
var total : int = 0


func _ready() -> void:
	visible = false
	self.get_viewport().set_embedding_subwindows(false)
	get_viewport().transparent = true
	get_viewport().transparent_bg = true
	get_viewport().always_on_top = true
	
	game_manager.connect("toggle_debug_ui", _on_game_manager_toggle_debug_ui)
	
	for child in scene.get_children():
		if child is Player:
			who.append(child)
			VB[total]["label"].text = str('P', child.pp.player_number, ' : ', child.pp._name)
			total += 1
			

func _physics_process(delta):
	for i in range(total):
		if who[i] != null:
			VB[i]["percentage"].placeholder_text = str(who[i].percentage)
			VB[i]["angry"].placeholder_text = str(who[i].angry)



func _on_game_manager_toggle_debug_ui(is_debugging : bool):
	if is_debugging:
		visible = true
	else:
		visible = false



##### 修改数值的信号
func _on_percentage_0_text_submitted(new_text):
	if who[0] != null:
		var value = float(new_text)
		who[0].percentage = value

func _on_angry_0_text_submitted(new_text):
	if who[0] != null:
		var value = float(new_text)
		who[0].angry = value

func _on_parcentage_1_text_submitted(new_text):
	if who[1] != null:
		var value = float(new_text)
		who[1].percentage = value

func _on_angry_1_text_submitted(new_text):
	if who[1] != null:
		var value = float(new_text)
		who[1].angry = value

func _on_parcentage_2_text_submitted(new_text):
	if who[2] != null:
		var value = float(new_text)
		who[2].percentage = value

func _on_angry_2_text_submitted(new_text):
	if who[2] != null:
		var value = float(new_text)
		who[2].angry = value

###################



##### 固定数值的信号
func _on_p_0_pressed():
	if who[0] != null:
		who[0].fixed_percentage = !who[0].fixed_percentage

func _on_a_0_pressed():
	if who[0] != null:
		who[0].fixed_angry = !who[0].fixed_angry

func _on_p_1_pressed():
	if who[1] != null:
		who[1].fixed_percentage = !who[1].fixed_percentage

func _on_a_1_pressed():
	if who[1] != null:
		who[1].fixed_angry = !who[1].fixed_angry

func _on_p_2_pressed():
	if who[2] != null:
		who[2].fixed_percentage = !who[2].fixed_percentage

func _on_a_2_pressed():
	if who[2] != null:
		who[2].fixed_angry = !who[2].fixed_angry
	
###################
