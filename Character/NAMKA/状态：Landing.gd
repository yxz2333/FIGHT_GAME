extends State

class_name LandingState

@export var jump_velocity : float = -200.0

@export var ground_state : State
@export var air_state : State

@export var jump_action : String

@export var move_animation : String
@export var jump_end_animation : String
@export var jump_start_animation : String

func state_process(delta) -> void:
	if not character.is_still(): # 着陆时按了方向键
		next_state = ground_state
		playback.travel(move_animation)


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(jump_action): # 着陆时按了跳跃键
		jump()


func jump() -> void: 
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_start_animation)
	
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == jump_end_animation:
		next_state = ground_state
		playback.travel(move_animation)
