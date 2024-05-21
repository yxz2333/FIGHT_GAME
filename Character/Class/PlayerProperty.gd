extends Node

class_name PlayerProperty

### 玩家编号对应单独信号
var angry_bar_player_signal = {
	1:"angry_bar_change_player_1",
	2:"angry_bar_change_player_2",
	3:"angry_bar_change_player_3",
	4:"angry_bar_change_player_4",
}

const SA_wait_time = {
	"character_select" : 7,
	"solo" : 7,
	"party" : 10
}

@export var character : Player

## 名字和编号
@export var _name : String
var player_number : int


## 移速、重量
@export var speed : float
@export var weight : float
var SA_speed : float


## 跳跃
@export var jump_velocity : float
@export var double_jump_velocity : float


## 攻击伤害与击飞
@export var damage : float
@export var base_knockback_speed : float
@export var extra_knockback_speed : float
## Party模式击飞
@export var party_kb : Dictionary = {
	'1v1v1' : Vector2(0, 0),
	'1v1' : Vector2(0, 0),
}


## 攻击镜头震动 (1 V 1) : solo 全程使用， party 仅在只剩 2 名玩家的时候使用
@export var camera_shake_offset : Vector2 # 镜头偏移量
@export var camera_shake_zoom : Vector2 # 镜头缩放
@export var camera_shake_duration : float # 镜头震动时间
@export var frame_freeze_duration : float # 卡帧持续时间
@export var time_scale : float # 卡帧降速


## 上下左右跳跃按键
@export var left_action : String
@export var right_action : String
@export var up_action : String
@export var down_action : String
@export var attack_action : String
@export var shot_action : String
@export var switch_gun_mode_action : String
@export var jump_action : String
@export var break_action : String
@export var SA_action : String
var attack_cancel : String


## 各个状态
@export var air_state : State
@export var break_state : State
@export var hit_state : State
@export var attack_state : State
@export var ground_default_state : State


## 动画
@export var move_animation : String = "移动"
@export var jump_start_animation : String = "跳跃_开始"
@export var jump_loop_animation : String = "跳跃_循环"
@export var double_jump_animation : String = "跳跃_连跳"
@export var hit_animation : String = "受伤"
@export var break_animation : String = "爆发"


func _ready():
	if character.scene.mode == "party" and character.scene.game_manager.number > 2:  # 交换party和默认的击飞速度
		base_knockback_speed = party_kb["1v1v1"].x
		extra_knockback_speed = party_kb["1v1v1"].y
		character.scene.phantom_camera.FF = false
	
	SA_speed = speed * 1.5


var actions = {
	"left_action" = "left_player_",                          # a 左
	"right_action" = "right_player_",                        # d 右
	"up_action" = "up_player_",                              # w 上
	"down_action" = "down_player_",                          # s 下
	"attack_action" = "attack_1_player_",                    # j 1
	"shot_action" = "attack_1_player_",                      # j 1
	"switch_gun_mode_action" = "switch_to_gun_mode_player_", # u 4
	"jump_action" = "jump_player_",                          # k 2
	"break_action" = "break_player_",                        # i 5
	"SA_action" = "SA_player_",                              # o 6
	"attack_cancel" = "3_cancel_player_",                    # l 3
}

func init_input(input_c):
	left_action    = actions.get("left_action") + str(input_c)
	right_action   = actions.get("right_action") + str(input_c)
	up_action      = actions.get("up_action") + str(input_c)
	down_action    = actions.get("down_action") + str(input_c)
	attack_action  = actions.get("attack_action") + str(input_c)
	shot_action    = actions.get("shot_action") + str(input_c)
	switch_gun_mode_action = actions.get("switch_gun_mode_action") + str(input_c)
	jump_action    = actions.get("jump_action") + str(input_c)
	break_action   = actions.get("break_action") + str(input_c)
	SA_action      = actions.get("SA_action") + str(input_c)
	attack_cancel  = actions.get("attack_cancel") + str(input_c)
