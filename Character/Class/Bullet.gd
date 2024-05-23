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


func check_if_myself(body : Player) -> bool: # 自己的子弹不会打到自己
	if body == player:
		return true
	else:
		return false

func handle_bullet_flip(body : Player) -> bool:
	if body.state_machine.current_state is DefenseState:
		body.state_machine.current_state.bulled_flip(self)
		return true
	return false


func _on_body_entered(body : Player): # 碰撞逻辑
	if handle_bullet_flip(body): # 被当身
		return
		
	if check_if_myself(body) or body.state_machine.check_if_cannot_hurt():
		return
		
	for child in body.get_children():
		if child is Damageable:
			if not is_instance_valid(player):
				player = null
			child.hit(damage, player)
			queue_free()
