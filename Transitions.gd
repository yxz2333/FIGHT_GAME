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

var thread : Thread
var packed_scene : PackedScene


func tran_in(num : int) -> float:
	var node = get_tree().root
	
	var instanced_scene = trans[num].instantiate()
	node.add_child(instanced_scene)
	
	var anim_player = instanced_scene.get_child(1) as AnimationPlayer
	anim_player.play("T_in")
	
	return 0.5


func tran_out(num : int) -> float:
	var node = get_tree().root
	
	var instanced_scene = trans[num].instantiate()
	node.add_child(instanced_scene)
	
	var anim_player = instanced_scene.get_child(1) as AnimationPlayer
	anim_player.play("T_out")
	
	return 0.5



func running_loading(str : String = "") -> float:
	var node = get_tree().root
	
	var load_instance = loading_scene.instantiate()
	var anim_player = load_instance.get_child(2) as AnimationPlayer
	node.add_child(load_instance)
	
	if str != "":
		anim_player.play(str)
	else:
		var ranint : int = randi_range(0, 2)
		anim_player.play(anim_name[ranint])
	
	return 2.4


func tran_d_0(PATH : String, lambda = null) -> void:   # 第1个默认过渡动画
	_create_thread(PATH)
	
	await get_tree().create_timer(tran_in(0)).timeout
	
	var b : ColorRect = _black_tran()
	await get_tree().create_timer(0.1).timeout
	b.queue_free()
	
	_change_scene(lambda)
	
	await get_tree().create_timer(running_loading()).timeout
	await get_tree().create_timer(tran_out(0)).timeout



func tran_d_0_without_loading(PATH : String, lambda = null) -> void:  # 第1个默认过渡动画（无loading）
	_create_thread(PATH)
	
	await get_tree().create_timer(tran_in(0)).timeout
	
	var b : ColorRect = _black_tran()
	await get_tree().create_timer(0.1).timeout
	b.queue_free()
	
	_change_scene(lambda)
	
	await get_tree().create_timer(tran_out(0)).timeout
	


func tran_d_0_without_loading_and_out(PATH : String, lambda = null) -> void:  # 第1个默认过渡动画（无loading,out）
	_create_thread(PATH)
	
	await get_tree().create_timer(tran_in(0)).timeout

	var b : ColorRect = _black_tran()
	await get_tree().create_timer(0.1).timeout
	b.queue_free()
	
	_change_scene(lambda)


func tran_d_0_without_in_and_loading(PATH : String, lambda = null) -> void:   # 第1个默认过渡动画（无in,loading）
	_create_thread(PATH)
	
	var b : ColorRect = _black_tran()
	await get_tree().create_timer(0.1).timeout
	b.queue_free()
	
	_change_scene(lambda)
	
	await get_tree().create_timer(tran_out(0)).timeout
	









func _black_tran() -> ColorRect:                              # 纯黑屏幕转场
	var black_tran : ColorRect = ColorRect.new()
	black_tran.color = Color.BLACK
	black_tran.size = Vector2(8000, 8000)
	black_tran.position = Vector2(-1280,-720)
	black_tran.z_index = 1
	get_tree().root.add_child(black_tran)

	return black_tran


func _change_scene(lambda = null) -> void:
	if thread.is_alive():
		packed_scene = thread.wait_to_finish()                 # 获取线程函数的返回值
	
	if lambda == null:
		var scene_instance = packed_scene.instantiate()
		get_tree().root.add_child(scene_instance)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = scene_instance
	else:
		lambda.call()
	
	packed_scene = null
	thread = null


## 启动多线程加载场景
func _load_scene_in_thread(path_to_scene: String) -> PackedScene:
	packed_scene = ResourceLoader.load(path_to_scene)
	return packed_scene

func _create_thread(path_to_scene: String) -> void:
	thread = Thread.new()
	var callable = Callable(self, "_load_scene_in_thread")
	thread.start(callable.bind(path_to_scene), Thread.PRIORITY_HIGH)
