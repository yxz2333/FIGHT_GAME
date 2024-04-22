extends Node

class_name Transition

var trans : Array[PackedScene] = [
	preload("res://Scene/T_1.tscn"),
]

var anim_name : Array[String] = [
	"namka",
	"marston",
	"musashi",
]

var loading_scene : PackedScene = preload("res://Scene/loading.tscn")

func tran_in(node, num : int):
	var instanced_scene = trans[num].instantiate()
	node.add_child(instanced_scene)
	
	var anim_player = instanced_scene.get_child(1) as AnimationPlayer
	anim_player.play("T_in")



func tran_out(node, num : int):
	var instanced_scene = trans[num].instantiate()
	node.add_child(instanced_scene)
	
	var anim_player = instanced_scene.get_child(1) as AnimationPlayer
	anim_player.play("T_out")



func loading(node, str : String = ""):
	var load_instance = loading_scene.instantiate()
	var anim_player = load_instance.get_child(3) as AnimationPlayer
	node.add_child(load_instance)
	anim_player.play("namka")
	#if str != "":
		#anim_player.play(str)
	#else:
		#var ranint : int = randi_range(0, 2)
		#anim_player.play(anim_name[ranint])

