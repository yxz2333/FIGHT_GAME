extends Area2D

class_name Bullet

var player : Player
var player_property : PlayerProperty
var direction : float
var speed : float
var damage : float
var percentage : float

@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	direction = 1 if player.sprite.flip_h == false else -1
	sprite.flip_h = player.sprite.flip_h
	speed = player_property.bullet_speed
	damage = player_property.bullet_damage

func _process(delta): # 子弹就开高帧率了，看着舒服
	position.x += speed * direction * delta


func _on_body_entered(body : Player): # 碰撞逻辑
	for child in body.get_children():
		if child is Damageable:
			
			if is_instance_valid(player):  # 释放的对象不能传入函数
				player = null
			child.hit(damage, player)
			queue_free()
