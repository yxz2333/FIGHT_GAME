extends Node

class_name PlayerProperty

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

## 子弹属性
@export var bullet_speed : float
@export var bullet_damage : float
@export var bullet_freeze_time : float

## 状态、动画、输入
@export var shot_action : String
@export var shot_animation : String


@export var action_animation = {
	## 左右上下输入
	"left_action" : "",
	"right_action" : "",
	"up_action" : "",
	"down_action" : "",
	 
	## 移动
	"move_animation" : "",
	#"move_gun_animation" : "",
	
	## 跳跃
	"jump_action" : "",
	"jump_start_animation" : "",
	"jump_loop_animation" : "",
	"double_jump_animation" : "",
	
	## 受伤
	"hit_animation" : "",
	
	## 射击
	"shot_action" : "",
	"shot_animation" : "",
	
	### 攻击
	#"attack_action" : "",
	#"attack_animation" : "",
	
	## 切换持枪状态
	"switch_gun_mode_action" : "",
	"switch_mode_animation" : "",
	
	
}
