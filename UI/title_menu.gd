extends Control

@onready var new_game : Button = $VBoxContainer/StartButton
@onready var v_box_container : VBoxContainer = $VBoxContainer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
var is_pressed : bool = false

func _ready():
	animation_player.play("按下任意键之前的title")
	
	for button : BaseButton in v_box_container.get_children(): 
		button.mouse_entered.connect(button.grab_focus)  # 设置鼠标焦点

func _input(event):
	if event is InputEventKey and not is_pressed:
		animation_player.play("按下任意键之后的title")
		is_pressed = true


var is_start_pressed : bool = false
func _on_start_button_pressed():
	if is_start_pressed:
		return
		
	is_start_pressed = true
	Transitions.tran_d_0_without_loading("res://UI/mode_select.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "按下任意键之后的title":
		new_game.grab_focus() # 设置键盘初始焦点
