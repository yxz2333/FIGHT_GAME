extends CharacterBody2D


const SPEED = 200.0

@onready var cp : CanvasLayer = $"../CanvasLayer"

@export var actions : Dictionary = {
	0 : "left_player_",
	1 : "right_player_",
	2 : "up_player_",
	3 : "down_player_"
}

func _physics_process(delta):
	print(cp.get_final_transform().origin)
	
	var direction = Input.get_vector(actions[0], actions[1], actions[2], actions[3])
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
