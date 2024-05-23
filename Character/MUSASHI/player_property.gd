extends PlayerProperty

@export var defense_state : State
@export var counter_attack_state : State
@export var flash_state : State
@export var flash_end_state : State
@export var charge_state : State

@export var charge_animation : String = "蓄力"
@export var defense_animation : String = "防御"
@export var counter_attack_1_animation : String = "防反_1"
@export var counter_attack_2_animation : String = "防反_2"
@export var flash_animation : String = "闪避"
@export var flash_end_animation : String = "闪避_结束"



@export var charge_time : Dictionary = {
	"character_select" : 1.5,
	"party" : 3.0,
	"solo" : 1.5,
}

@export var dash : Vector2 = Vector2(150.0, 0.0)
@export var counter_attack_damage : float = 15.0

## 基础伤害、屏幕震动、击退
## 各基础属性根据 蓄力蓄满 设置
## 实际使用的参数根据 基础属性 和 timer 来动态调整
@export var base : Dictionary = {
	"damage" : 30.0,
	"base_knockback_speed" : 70.0,
	"extra_knockback_speed" : 0.0,
	"party" : {
		"1v1" : Vector2(140.0, 0.0),
		"1v1v1" : Vector2(30.0, 0.0),
	},
	"camera_shake_duration" : 0.9,
	"frame_freeze_duration" : 0.9,
}
