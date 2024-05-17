extends Node2D

class_name Scene

@export var tilemap_limit_left : float = -340.0
@export var tilemap_limit_right : float = 340.0
@export var tilemap_limit_bottom : float = 184.0

var inputs = {  # 在character_select中更改
	"MARSTON" : 1,
	"NAMKA" : 2,
	"MUSASHI" : 3,
}

var can_input : bool = true

@export var mode : String

@export var birth_markers : Array[Marker2D] = []
