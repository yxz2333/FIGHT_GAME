extends CharacterBody2D

@onready var label : Label = $Label
@onready var texture : AnimatedSprite2D = $AnimatedSprite2D


## 一些要拷贝实例化的
var shader_code : Shader = preload("res://UI/mode_select_character.gdshader")
var label_tres : LabelSettings = preload("res://UI/player_select.tres")

var num : int
var direction : Vector2 = Vector2.ZERO
var speed : Vector2 = Vector2(250, 250)
var colors = [Color.RED, Color.DEEP_SKY_BLUE, Color.YELLOW]
var actions = ["left_player_", "right_player_", "up_player_", "down_player_"]


func _ready():
	label.label_settings = label_tres.duplicate()
	label.text = "P" + str(num)
	label.label_settings.font_color = colors[num - 1]
	add_child(label)
	
	var shader_material = ShaderMaterial.new().duplicate() # 创建副本，这样各个节点不会共一个节点了
	shader_material.shader = shader_code
	shader_material.set_shader_parameter("outlineColor", colors[num - 1]) # 修改shader属性函数
	shader_material.set_shader_parameter("outlineWidth", 0.05)
	texture.material = shader_material

func _physics_process(delta):
	direction = Input.get_vector(actions[0], actions[1], actions[2], actions[3])
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed.x)
		velocity.y = move_toward(velocity.y, 0, speed.y)
	move_and_slide()
