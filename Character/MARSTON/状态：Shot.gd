extends ShotState

@onready var timer : Timer = $Timer

var bullets_number : int

var check_if_can_shot : bool

func _ready():
	bullets_number = player_property.maximum_bullets
	check_if_can_shot = 0  

func on_enter() -> void:
	if bullets_number <= 0: # 子弹没了直接返回
		_return()
		return
	
	super()
	timer.start()
	playback.travel(shot_animation)
	check_if_can_shot = 0
	
func shot() -> void:
	var bullet_instantiate = bullet.instantiate()
	bullet_instantiate.player = player
	bullet_instantiate.player_property = player_property
	
	bullet_instantiate.global_position = bullet_start_marker.global_position
	player.add_sibling(bullet_instantiate)


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed(shot_action) and check_if_can_shot and bullets_number > 0: # 多次开枪
		timer.start()
		anim_player.seek(0, true)
		anim_player.play(shot_animation)
		check_if_can_shot = 0

	if event.is_action_pressed(player_property.left_action) or event.is_action_pressed(player_property.right_action):
		_return()

func _change_to_can_shot() -> void: # 开完枪后check_if_can_shot设为1，即可以连续再开一枪
	check_if_can_shot = 1
	bullets_number -= 1
	print(bullets_number)

func _physics_process(delta):
	if timer.is_stopped() and character_state_machine.current_state is ShotState:
		_return()
