extends Node

class_name CharacterStateMachine

@export var character : Player
@export var current_state : State
@export var animation_tree : AnimationTree
@export var _default_ground_state : State
@export var _default_ground_animation : String

var states : Array[State]

@export var attack_area : Area2D

## 初始化各个状态
func _ready():
	for child in get_children():
		if child is State:
			states.append(child) # 添加状态
			
			child.return_to_ground_state = _default_ground_state              # 子节点绑定默认落地返回状态
			child.return_to_ground_animaton = _default_ground_animation       # 子节点绑定默认落地返回状态的动画
			child.character = character                                       # 子节点绑定角色
			child.playback = animation_tree["parameters/playback"]            # 子节点状态绑定动画树
			
			child.connect("interrupt_state", _on_state_interrupt_state)
			
		else:
			push_warning("子节点" + child.name + "不是一个状态")


func _physics_process(delta):
	if current_state.next_state != null:
		switch_states(current_state.next_state)
	
	current_state.state_process(delta)


func _input(event : InputEvent):
	current_state.state_input(event)


func _on_state_interrupt_state(new_state : State):  # 可以手动提前切换状态
	switch_states(new_state)
	

func check_if_can_move() -> bool:
	return current_state.能否跑
	
func check_if_can_overturn() -> bool:
	return current_state.能否转向


func switch_states(new_state : State) -> void:
	attack_area.monitoring = false                 # 只有attack状态才激活hitbox

	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
		
	new_state.return_to_ground_state = current_state.return_to_ground_state        # 更新落地返回状态
	new_state.return_to_ground_animaton = current_state.return_to_ground_animaton  # 更新落地返回状态
	
	current_state = new_state
	
	current_state.on_enter()
