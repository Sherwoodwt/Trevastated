class_name Float
extends Node2D

@export var enabled: bool = true
@export var float_distance: float = 20
@export var speed: float = 3


var _end: float
var _start: float
var _ellapsed: float

func _ready():
	_end = position.y + float_distance
	_start = position.y
	
func _process(delta: float) -> void:
	if !enabled:
		return

	_ellapsed += delta
	if _ellapsed > TAU:
		_ellapsed -= TAU
	position.y = lerpf(_start, _end, (sin(_ellapsed * speed) + 1) / 2)
