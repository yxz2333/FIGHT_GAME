extends Node2D

class_name Scene

@export var tilemap_limit_left : float = -340.0
@export var tilemap_limit_right : float = 340.0

var input = {  # 在character_select中更改
	"MARSTON" : 1,
	"NAMKA" : 2,
	"MUSASHI" : 3,
}
