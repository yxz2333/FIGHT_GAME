extends State

class_name ShotState

@onready var bullet_freeze_timer : Timer = $BulletFreezeTimer
@onready var buffer_timer : Timer = $BufferTimer

var shot_action : String

func _ready():
	shot_action = player_property.shot_action


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(shot_action) and bullet_freeze_timer.is_stopped():
		buffer_timer.start()
		
