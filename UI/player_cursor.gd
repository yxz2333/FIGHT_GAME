extends CharacterBody2D

class_name PlayerCursor

@onready var label : Label = $Label
@onready var texture : AnimatedSprite2D = $AnimatedSprite2D
var out : PackedScene = preload("res://Scene/out!.tscn")

var num : int
var input_num
var menu : CharacterSelectMenu

var accept_inputs = {
	74 : 1,             # KEY_J 的code
	4194439 : 2,        # KEY_1 的code
	0 : 3,              # JOY_BUTTON_A 的code 
}

## 一些要拷贝实例化的
var shader_code : Shader = preload("res://UI/mode_select_character.gdshader") # shader代码
var label_tres : LabelSettings = preload("res://UI/player_select.tres")       # label_setting


var direction : Vector2 = Vector2.ZERO
var speed : Vector2 = Vector2(250, 250)
var colors = [Color.RED, Color.DEEP_SKY_BLUE, Color.YELLOW]
var actions = ["left_player_", "right_player_", "up_player_", "down_player_"]

var current_selection : PlayerSelectMenuUI  # 现在指针over的player_UI
var is_selected : bool = false



func init(n : int, me : CharacterSelectMenu, accept_input) -> void:
	num = n
	menu = me
	input_config(accept_input)

func _ready():
	is_selected = false
	label_init()
	shader_material_init()
	SignalBus.connect("player_out_of_screen", _back)


func _physics_process(delta):
	if not is_selected:
		direction = Input.get_vector(actions[0], actions[1], actions[2], actions[3])
		if direction:
			velocity = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed.x)
			velocity.y = move_toward(velocity.y, 0, speed.y)
	
	
		move_and_slide()


func _input(event):
	if event.is_action_pressed("ui_accept") and current_selection != null and not is_selected: # over到可选择角色时，按accept选择
		current_selection.select(num, input_num) # 选择完实例化可操纵角色
		hide()                                   # 指针隐藏
		is_selected = true
		global_position = menu.back_markers[num - 1].position # 隐藏完归位



func label_init() -> void:
	label.label_settings = label_tres.duplicate()
	label.text = "P" + str(num)
	label.label_settings.font_color = colors[num - 1]

func shader_material_init() -> void:
	var shader_material = ShaderMaterial.new().duplicate() # 创建副本，这样各个节点不会共一个节点了
	shader_material.shader = shader_code
	shader_material.set_shader_parameter("outlineColor", colors[num - 1]) # 修改shader属性函数
	shader_material.set_shader_parameter("outlineWidth", 0.05)
	texture.material = shader_material


func _on_area_2d_area_entered(area):
	if area.get_parent() is PlayerSelectMenuUI:
		var par_a = area.get_parent() as PlayerSelectMenuUI
		par_a.start()
		current_selection = par_a

func _on_area_2d_area_exited(area):
	if area.get_parent() is PlayerSelectMenuUI:
		area.get_parent().exit()
		current_selection = null



func input_config(accept_input) -> void:
	input_num = accept_inputs.get(accept_input)
	for i in range(actions.size()):
		actions[i] += str(input_num) # 分配按键


func _back(node : Player) -> void:
	show()
	is_selected = false
	
	var out_instance = out.instantiate()
	
	print(node.position.y)
	## 设置out位置
	if node.position.y < menu.tilemap_limit_bottom:
		out_instance.rotation_degrees = 0.0
		if node.position.x < 0:
			out_instance.flip_h = false
			out_instance.global_position = Vector2(-120, node.position.y)
		elif node.position.x > 0:
			out_instance.flip_h = true
			out_instance.global_position = Vector2( 120, node.position.y)
	else:
		out_instance.rotation_degrees = -90.0
		out_instance.scale = Vector2(0.5, 0.5)
		if node.position.x < 0:
			out_instance.flip_h = false
			out_instance.global_position = Vector2(node.position.x, menu.tilemap_limit_bottom - 172)
		else:
			out_instance.flip_h = true
			out_instance.global_position = Vector2(node.position.x, menu.tilemap_limit_bottom - 172)
			
	
	add_sibling(out_instance)
	await get_tree().create_timer(0.25).timeout # 等待0.25秒
	out_instance.queue_free()
