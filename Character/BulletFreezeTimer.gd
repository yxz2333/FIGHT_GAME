extends Timer

@export var player_property : PlayerProperty

func _ready():
	wait_time = player_property.bullet_freeze_time
