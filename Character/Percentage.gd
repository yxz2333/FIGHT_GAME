extends Control

@export var player : Player
@onready var label : Label = $Label

@export var is_right : bool

var timer : Timer
#var tween : Tween

func _ready():
	#tween = get_tree().create_tween()
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.5
	global_position = Vector2(585 if is_right else 20, 27)
	

var last_test : String = str(0.0) + "%"
func _physics_process(delta):
	label.text = str(player.percentage) + "%"
	if last_test != label.text: # 百分比改变进行的动画
		var tween = get_tree().create_tween()
		
		## 变色，变大，抖动
		var original_global_position : Vector2 = global_position
		tween.tween_property(label, "modulate", Color.RED, 0.1)
		tween.parallel().tween_property(label, "scale", Vector2(1.25, 1.25), 0.1)
		tween.parallel().tween_property(label, "global_position", global_position + Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.01)
		tween.parallel().tween_property(label, "global_position", global_position + Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.01).set_delay(0.11)
		
		## 恢复之前的状态
		tween.tween_property(label, "global_position", original_global_position, 0.05).set_delay(0.15)
		tween.parallel().tween_property(label, "scale", Vector2(1, 1), 0.1)
		tween.parallel().tween_property(label, "modulate", Color.WHITE, 0.1).set_delay(0.5)
		
		## 更新
		last_test = label.text
