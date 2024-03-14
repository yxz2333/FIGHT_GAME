extends Control

@onready var new_game : Button = $VBoxContainer/StartButton
@onready var v_box_container : VBoxContainer = $VBoxContainer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var freeze_timer : Timer = $FreezeTimer
var is_press : bool = false

func _ready():
	animation_player.play("按下任意键之前的title")

	freeze_timer.start()
	
	new_game.grab_focus() # 设置键盘初始焦点
	
	for button : BaseButton in v_box_container.get_children(): 
		button.mouse_entered.connect(button.grab_focus)  # 设置鼠标焦点

func _input(event):
	if event is InputEventKey and not is_press and freeze_timer.is_stopped():
		animation_player.play("按下任意键之后的title")
		is_press = true
		freeze_timer.wait_time = 0.5
		freeze_timer.start()


func _on_start_button_pressed():
	if freeze_timer.is_stopped():
		get_tree().change_scene_to_file("res://Scene/Level-1.tscn")
	

func _on_quit_button_pressed():
	get_tree().quit()
	

