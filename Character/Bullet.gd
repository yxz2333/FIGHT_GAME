extends Area2D

var player : Player
var player_property : PlayerProperty
var direction : float
var speed : float
var damage : float

func _ready():
	speed = player_property.bullet_speed
	damage = player_property.bullet_damage

func _process(delta):
	direction = 1 if player.sprite.flip_h == false else -1
	position.x += speed * direction * delta
