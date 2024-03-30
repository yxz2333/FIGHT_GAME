extends Node

class_name PlayerProperty

## 玩家编号对应单独信号
var angry_bar_player_signal = {
	1:"angry_bar_change_player_1",
	2:"angry_bar_change_player_2",
	3:"angry_bar_change_player_3",
	4:"angry_bar_change_player_4",
}


## 名字和玩家编号
@export var _name : String
@export var player_number : int


## 移速、重量
@export var speed : float
@export var weight : float

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
