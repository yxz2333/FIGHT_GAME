extends Label

@export var state_machine : CharacterStateMachine

func _physics_process(delta):
	text = "状态：" + state_machine.current_state.name
