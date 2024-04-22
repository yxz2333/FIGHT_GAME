extends CharacterBody2D

class_name PlayerCursor

@onready var label : Label = $Label
@onready var texture : AnimatedSprite2D = $AnimatedSprite2D
var sprite_marker : Node2D
var out : PackedScene = preload("res://Scene/out!.tscn")

var num : int
var input_num
var sprite_markers : Array[Marker2D] = [] # 0：in、1：out
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


var sprite : Sprite2D = null
var s_label : Label = null


func init(n : int, me : CharacterSelectMenu, accept_input, sm : Node2D = null) -> void:
	num = n
	menu = me
	sprite_marker = sm
	input_config(accept_input)

func _ready():
	is_selected = false
	label_init()
	shader_material_init()
	
	SignalBus.connect("player_out_of_screen", _back)
	
	if sprite_marker != null:
		for child in sprite_marker.get_children():
			sprite_markers.append(child)


func _physics_process(delta):
	if is_selected:
		return
	
	
	direction = Input.get_vector(actions[0], actions[1], actions[2], actions[3])
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed.x)
		velocity.y = move_toward(velocity.y, 0, speed.y)
	
	move_and_slide()


func _input(event):
	if event.is_action_pressed("ui_accept") and current_selection != null and not is_selected: # over到可选择角色时，按accept选择
		## 检测当前accept是否是对应键位
		if event is InputEventKey:
			if input_num != accept_inputs.get(event.keycode):
				return
		if event is InputEventJoypadButton:
			if input_num != accept_inputs.get(event.keycode):
				return
		
		
		current_selection.select(self, num, input_num) # 选择完实例化可操纵角色
		_sprite_effect()                         # 生成人物图标
		hide()                                   # 指针隐藏
		is_selected = true
		global_position = menu.back_markers[num - 1].position # 隐藏完归位


func _sprite_effect():                   # 生成人物图标
	if sprite_marker == null:
		return
	
	var in_num    : int = 0 + (num - 1) * 3
	var out_num   : int = 1 + (num - 1) * 3
	var label_num : int = 2 + (num - 1) * 3
	
	## sprite
	sprite = current_selection.get_child(3).duplicate()
	sprite.position = sprite_markers[out_num].position # 一开始在out位
	sprite.scale = Vector2(8,8)
	sprite.modulate = Color(1, 1, 1, 0.68)
	
	## 翻转sprite，并适配一下solo和party的选人方式
	if menu.total_players == 2:
		sprite.flip_h = false if num == 1 else true
	elif menu.total_players == 3:
		pass
	add_sibling(sprite)
	
	## label
	s_label = label.duplicate()
	s_label.position = sprite_markers[label_num].position
	add_sibling(s_label)
	
	## tween动画
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(sprite, "position", sprite_markers[in_num].position, 0.3).set_ease(Tween.EASE_OUT)



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
		par_a.start(self)
		current_selection = par_a

func _on_area_2d_area_exited(area):
	if area.get_parent() is PlayerSelectMenuUI:
		var par_a = area.get_parent() as PlayerSelectMenuUI
		par_a.exit(self)
		current_selection = null



func input_config(accept_input) -> void: # 配置鼠标指针输入，初始化input_num
	input_num = accept_inputs.get(accept_input)
	for i in range(actions.size()):
		actions[i] += str(input_num) # 分配按键


func _back(node : Player) -> void:       # 人物出界，重选人物，out特效，sprite关掉
	if node.pp.player_number != num:  # 匹配编号
		return
	
	menu.selected_player -= 1
	
	show()
	is_selected = false
	
	var out_instance = out.instantiate()
	
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
			out_instance.flip_v = false
			out_instance.global_position = Vector2(node.position.x, menu.tilemap_limit_bottom - 172)
		else:
			out_instance.flip_v = true
			out_instance.global_position = Vector2(node.position.x, menu.tilemap_limit_bottom - 172)
	add_sibling(out_instance)
	
	
	sprite.queue_free()                         # sprite关掉
	s_label.queue_free()                        # label关掉
	await get_tree().create_timer(0.25).timeout # 等待0.25秒
	out_instance.queue_free()                   # out删掉