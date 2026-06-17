extends CharacterBody2D

@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D

@export var _min_wait_time: float
@export var _max_wait_time: float
@export var _min_speed: float
@export var _max_speed: float
@export var _bounds: Vector2 = Vector2(430, 220)
@export var _max_distance: float = 200
@export var _random_start: bool

@onready var _target: Vector2 = position
var _speed: float
var _moving: bool

func _ready():
	if _random_start:
		var x = randf_range(-_bounds.x, _bounds.x)
		var y = randf_range(-_bounds.y, _bounds.y)
		position = Vector2(x, y)
	timer.timeout.connect(set_target)
	_reset_timer()

func _reset_timer():
	var time = randf_range(_min_wait_time, _max_wait_time)
	timer.start(time)

func set_target():
	timer.stop()
	_moving = true
	var x = clampf(randf_range(-_bounds.x, _bounds.x), position.x - _max_distance, position.x + _max_distance)
	var y = clampf(randf_range(-_bounds.y, _bounds.y), position.y - _max_distance, position.y + _max_distance)
	_target = Vector2(x, y)
	_speed = randf_range(_min_speed, _max_speed)

func _physics_process(delta: float) -> void:
	var dif = _target - position
	if dif.x > 0:
		sprite.flip_h = false
	if dif.x < 0:
		sprite.flip_h = true
	position = position.move_toward(_target, _speed * delta)
	if _moving && position == _target:
		_moving = false
		_reset_timer()
