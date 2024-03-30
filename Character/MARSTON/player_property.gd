extends PlayerProperty

var bullet_bar_player_signal = {
	1:"bullet_bar_change_player_1",
	2:"bullet_bar_change_player_2",
	3:"bullet_bar_change_player_3",
	4:"bullet_bar_change_player_4",
}

## 子弹属性
@export var bullet_speed : float
@export var bullet_damage : float
@export var maximum_bullets : int 
@export var bullet : PackedScene


## 各个状态
@export var shot_state : State
@export var ground_gun_state : State
@export var gun_start_state : State

## 动画
@export var shot_animation : String
@export var gun_start_animation : String = "拔枪"
@export var ground_gun_animation : String = "持枪移动"
