extends Node

extends CharacterStateMachine

@export var character : CharacterBody2D
@export var current_state : State
@export var animation_tree : AnimationTree

var states : Array[State]

## 初始化各个状态
func _ready():
	for child in get_children():
		if child is State:
			states.append(child) # 添加状态
			
			child.character = character # 子节点绑定角色
			child.playback = animation_tree["parameters/playback"] # 子节点状态绑定动画树
			
			child.connect("interrupt_state", _on_state_interrupt_state)
			
		else:
			push_warning("子节点" + child.name + "不是一个状态")


func _physics_process(delta):
	if current_state.next_state != null:
		switch_states(current_state.next_state)
	
	current_state.state_process(delta)


func _input(event : InputEvent):
	current_state.state_input(event)


func _on_state_interrupt_state(new_state : State):
	switch_states(new_state)
	

func check_if_can_move() -> bool:
	return current_state.能否跑
	
func check_if_can_overturn() -> bool:
	return current_state.能否转向


func switch_states(new_state : State) -> void:
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
		
	current_state = new_state
	
	current_state.on_enter()
