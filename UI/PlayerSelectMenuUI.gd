extends Control

class_name PlayerSelectMenuUI

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var collision : CollisionShape2D = $Area2D/CollisionShape2D
@onready var marker : Marker2D = $Marker2D
@export var menu : CharacterSelectMenu

var shader_colors : Array[Color] = []
var label_tres : LabelSettings = preload("res://Character/Class/P_label.tres")


var characters = {
	"Marston" : preload("res://Character/MARSTON/marston.tscn"),
	"Namka" : preload("res://Character/NAMKA/namka.tscn"),
	"Musashi" : preload("res://Character/MUSASHI/musashi.tscn"),
}

var shader_material : ShaderMaterial


func _ready():
	collision.shape.size = size
	collision.position += size / 2
	marker.position = collision.position
	pivot_offset = size / 2
	
	shader_material = ShaderMaterial.new().duplicate() # 创建副本，这样各个节点不会共一个节点了



func start(node : PlayerCursor) -> void:    # 指针进入框的动画
	var color : Color = node.colors[node.num - 1]
	if shader_colors.size() != 0:
		shader_colors.append(color)
		return
	
	shader_colors.append(color)
	anim_player.play("in")
	
	
	shader_material.shader = node.shader_code
	shader_material.set_shader_parameter("outlineColor", shader_colors[0]) # 修改shader属性函数
	shader_material.set_shader_parameter("outlineWidth", 0.05)
	material = shader_material

func exit(node : PlayerCursor) -> void:     # 指针退出框的动画
	var color : Color = node.colors[node.num - 1]
	if color != shader_colors[0]:  # exit的不是当前的颜色
		_colors_erase(color)
		return
	
	
	_colors_erase(color)
	if shader_colors.size() == 0:
		anim_player.play("out")
		material = null
	else:
		shader_material.set_shader_parameter("outlineColor", shader_colors[0])


func _colors_erase(color : Color) -> void:  # shader_colors删元素用
	while(shader_colors.has(color)):
		shader_colors.erase(color)



func select(cursor : PlayerCursor, player_num : int, input_num) -> void:  # 人物选好了进行实例化
	menu.selected_player += 1
	var born_position : Vector2 = marker.global_position
	
	var char_name : String = name # 所选人物名字
	
	## 人物实例化
	var character = characters[char_name].instantiate() as Player # 找实例化哪个人物
	character.init(menu, player_num, input_num)
	
	character.scale = Vector2(1.5, 1.5)
	character.canvas_layer.hide()
	character.global_position = born_position
	
	## P_label实例化
	var ls : LabelSettings = label_tres.duplicate()
	character.P_label.text = cursor.label.text
	character.P_label.label_settings = ls
	character.P_label.label_settings.font_color = cursor.colors[cursor.num - 1]
	
	menu.add_child(character)
