extends Node

class_name PlayerProperty

### 玩家编号对应单独信号
#var angry_bar_player_signal = {
	#1:"angry_bar_change_player_1",
	#2:"angry_bar_change_player_2",
	#3:"angry_bar_change_player_3",
	#4:"angry_bar_change_player_4",
#}




## 名字和玩家编号
@export var _name : String
@export var player_number : int


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

## 攻击镜头震动
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
@export var move_animation : String
@export var jump_start_animation : String
@export var jump_loop_animation : String
@export var double_jump_animation : String
@export var hit_animation : String
@export var break_animation : String = "爆发"


func _ready():
	SA_speed = speed * 1.5
	
	
	
var actions = {
	"left_action" = "left_player_",                          # a 左
	"right_action" = "right_player_",                        # d 右
	"up_action" = "up_player_",                              # w 上
	"down_action" = "down_player_",                          # s 下
	"attack_action" = "attack_1_player_",                    # j 1
	"shot_action" = "attack_1_player_",                     # j 1
	"switch_gun_mode_action" = "switch_to_gun_mode_player_", # u 4
	"jump_action" = "jump_player_",                          # k 2
	"break_action" = "break_player_",                        # i 5
	"SA_action" = "SA_player_",                              # o 6
	"attack_cancel" = "3_cancel_player_",                    # l 3
}

func init_input(num : int):
	player_number = num
	
	left_action    = actions.find_key("left_action") + str(num)
	right_action   = actions.find_key("right_action") + str(num)
	up_action      = actions.find_key("up_action") + str(num)
	down_action    = actions.find_key("down_action") + str(num)
	attack_action  = actions.find_key("attack_action") + str(num)
	shot_action    = actions.find_key("shot_action") + str(num)
	switch_gun_mode_action = actions.find_key("switch_gun_mode_action") + str(num)
	jump_action    = actions.find_key("jump_action") + str(num)
	break_action   = actions.find_key("break_action") + str(num)
	SA_action      = actions.find_key("SA_action") + str(num)
	attack_cancel  = actions.find_key("attack_cancel") + str(num)
