extends Control

@export var health_changed_label : PackedScene  # 提供场景属性
@export var damage_color : Color = Color.DARK_RED
@export var heal_color : Color = Color.DARK_GREEN


func _ready(): 
	SignalBus.connect("on_health_changed", _on_signal_health_changed)
	
	
func _on_signal_health_changed(node : Node, amount_changed : int):
	var label_instance : Label = health_changed_label.instantiate()   # health_changed_label场景实例化成Label
	node.add_child(label_instance)                  # 血量变化的对象添加子节点Label，用于显示血量变化
	label_instance.text = str(amount_changed)       # 显示血量文字设置
	
	if amount_changed >= 0:
		label_instance.modulate = heal_color
	else:
		label_instance.modulate = damage_color
		
