extends PlayerProperty

## 攻击取消按键
@export var attack_cancel : String

## 子弹属性
@export var bullet_speed : float
@export var bullet_damage : float
@export var bullet_freeze_time : float
@export var bullet : PackedScene

## 各个状态
@export var shot_state : State
@export var ground_gun_state : State
@export var gun_start_state : State

## 动画
@export var shot_animation : String
@export var gun_start_animation : String = "拔枪"
@export var ground_gun_animation : String = "持枪移动"
@export var attack_1_animation : String = "攻击_准备"
@export var attack_1_animation_left : String = "攻击_准备_左"
@export var attack_1_animation_right : String = "攻击_准备_右"
