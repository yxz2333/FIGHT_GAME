extends Area2D

class_name FlashBack

@onready var timer : Timer = $Timer
var character : Player


func init(c : Player):
	character = c

func _ready():
	timer.wait_time = 0.4
	timer.one_shot = true
	timer.start()
	connect("area_entered", _on_hit_back)

func _on_hit_back(area : Attack) -> void:
	character.angry += area.player.pp.damage * 1.5
	queue_free()

func _on_timer_timeout():
	queue_free()
