extends Area2D

var player : Player
var player_property : PlayerProperty
var direction : float
var speed : float
var damage : float

@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	direction = 1 if player.sprite.flip_h == false else -1
	sprite.flip_h = player.sprite.flip_h
	speed = player_property.bullet_speed
	damage = player_property.bullet_damage

func _process(delta):
	position.x += speed * direction * delta
