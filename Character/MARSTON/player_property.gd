extends PlayerProperty

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
@export var gun_start_animation : String
@export var ground_gun_animation : String
