extends Node2D

class_name Scene

var inputs = {  # 在character_select中更改
	"MARSTON" : 1,
	"NAMKA" : 2,
	"MUSASHI" : 3,
}

var can_input : bool = true

@export_enum("solo", "party", "character_select") var mode : String

@export var birth_markers : Array[Marker2D] = []
@export var camera : CameraSetting = null
@export var game_manager : GameManager = null
@export var limit_area : Area2D
@export var limit_coll : CollisionShape2D
@export var out_pos : Array[Vector2] = [Vector2(0, 1),Vector2(0, 1),Vector2(0, 1),Vector2(0, 1)]   # 左右上下


var out : PackedScene = preload("res://Scene/out!.tscn")

func _ready():
	limit_area.body_exited.connect(_on_limit_area_body_exited)


func create_out(node : Player) -> void:
	var out_instance = out.instantiate()
	
	## 左右上下
	var border : Vector4 = Vector4(-limit_coll.shape.size.x / 2, limit_coll.shape.size.x / 2,
								   -limit_coll.shape.size.y / 2, limit_coll.shape.size.y / 2)
	
	if node.position.x < border.x:     # 超过左边
		out_instance.scale = Vector2(out_pos[0].y, out_pos[0].y)
		out_instance.rotation_degrees = 0.0
		out_instance.flip_h = false
		out_instance.global_position = Vector2(out_pos[0].x, node.position.y)
		
	elif node.position.x > border.y:   # 超过右边
		out_instance.scale = Vector2(out_pos[1].y, out_pos[1].y)
		out_instance.rotation_degrees = 0.0
		out_instance.flip_h = true
		out_instance.global_position = Vector2(out_pos[1].x, node.position.y)
		
	elif node.position.y < border.z:   # 超过上边
		out_instance.scale = Vector2(out_pos[2].y, out_pos[2].y)
		out_instance.rotation_degrees = 90.0
		out_instance.flip_h = false
		out_instance.global_position = Vector2(node.position.x, out_pos[2].x)
		
	elif node.position.y > border.w:   # 超过下边
		out_instance.scale = Vector2(out_pos[3].y, out_pos[3].y)
		out_instance.rotation_degrees = 90.0
		out_instance.flip_h = true
		out_instance.global_position = Vector2(node.position.x, out_pos[3].x)
	
	add_child(out_instance)
	
	await get_tree().create_timer(0.25).timeout # 等待0.25秒
	out_instance.queue_free()                   # out删掉



func _on_limit_area_body_exited(body : Player):
	game_manager.emit_signal("player_out_of_screen", body)
