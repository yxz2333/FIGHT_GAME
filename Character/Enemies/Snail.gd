extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

@export var movement_speed : float = 35.0
@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var hit_state : State

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_tree.active = true  # 激活动画 

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction : Vector2 =  starting_move_direction
	if direction and state_machine.check_if_can_move():
		velocity.x = direction.x * movement_speed
		
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, movement_speed)

	move_and_slide()
