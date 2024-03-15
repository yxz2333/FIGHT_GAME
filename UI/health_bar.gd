extends HBoxContainer

@export var player_property : PlayerProperty
@export var character : CharacterBody2D

@onready var health_bar : TextureProgressBar = $HealthBar
@onready var eased_health_bar : TextureProgressBar = $HealthBar/EasedHealthBar

func _ready():
	SignalBus.health_bar_change.connect(_update_health_bar)
	health_bar.value = 1

func _update_health_bar() -> void:
	var percentage : float = character.health / float(player_property.original_health)
	health_bar.value = percentage
	
	## 制作红血条动画
	create_tween().tween_property(eased_health_bar, "value", percentage, 0.5)
