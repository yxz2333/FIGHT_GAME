extends Node

class_name PlayerProperty

@export var _name : String

## 移速、重量、生命值
@export var speed : float
@export var original_weight : float
@export var original_health : float

## 跳跃
@export var jump_velocity : float
@export var double_jump_velocity : float

## 攻击伤害与击飞
@export var damage : float
@export var knockback_speed : float
@export var angle : float

## 攻击镜头震动
@export var camera_shake_offset : Vector2 # 镜头偏移量
@export var camera_shake_zoom : Vector2 # 镜头缩放
@export var camera_shake_duration : float # 镜头震动时间
@export var frame_freeze_duration : float # 卡帧持续时间
@export var time_scale : float # 卡帧降速

## 死亡击飞体重
@export var kill_weight : float

## 上下左右跳跃按键
@export var left_action : String
@export var right_action : String
@export var up_action : String
@export var down_action : String
