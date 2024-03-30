extends TextureProgressBar

@export var bus : AngryBar

func _ready():
	max_value = bus.character.shot_freeze_timer.wait_time

func _physics_process(delta):
	value = max_value - bus.character.shot_freeze_timer.time_left
