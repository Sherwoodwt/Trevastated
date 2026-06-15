class_name Arrow
extends Control

@onready var _texture: TextureRect = $Float/Control/TextureRect
@onready var _rotater: Control = $Float/Control

var direction: int

func success():
	_texture.modulate.a = 0

func _ready():
	_rotater.rotation_degrees = 90 * direction

func attempt(dir: int) -> bool:
	var outcome = direction == dir
	if outcome:
		_texture.modulate.a = 0
	return outcome
