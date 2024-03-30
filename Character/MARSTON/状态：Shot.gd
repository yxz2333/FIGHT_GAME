extends ShotState

@onready var timer : Timer = $Timer

var check_if_can_shot : bool

func init():
	super() # 调用父类初始化
	character.bullets_number = pp.maximum_bullets
	check_if_can_shot = 0  

func on_enter() -> void:
	if character.bullets_number <= 0: # 子弹没了直接返回
		_return()
		return
	
	super() # 调用父类的子弹发射坐标翻转函数
	timer.start()
	playback.travel(pp.shot_animation)
	check_if_can_shot = 0
	
func shot() -> void:
	var bullet_instantiate = bullet.instantiate()
	bullet_instantiate.player = player
	bullet_instantiate.player_property = pp
	bullet_instantiate.global_position = bullet_start_marker.global_position
	player.add_sibling(bullet_instantiate)


func state_input(event : InputEvent) -> void:
	super(event)
	
	if event.is_action_pressed(pp.shot_action) and check_if_can_shot and character.bullets_number > 0: # 多次开枪
		timer.start()
		anim_player.seek(0, true)
		anim_player.play(pp.shot_animation)
		check_if_can_shot = 0

	if event.is_action_pressed(pp.left_action) or event.is_action_pressed(pp.right_action):
		_return()

func _change_to_can_shot() -> void: # 开完枪后check_if_can_shot设为1，即可以连续再开一枪
	check_if_can_shot = 1
	character.bullets_number -= 1

	for key in pp.bullet_bar_player_signal.keys(): # 找和玩家编号匹配的信号进行发送
		if key == pp.player_number:
			SignalBus.emit_signal(pp.bullet_bar_player_signal[key])

	print(character.bullets_number)

func _physics_process(delta):
	if timer.is_stopped() and character_state_machine.current_state is ShotState:
		_return()
