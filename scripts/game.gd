extends Node

signal high_stress(on: bool)

@onready var _timer: Timer = $DayTimer
@onready var _progress: TextureProgressBar = $CanvasLayer/TimerBar
@onready var _stress: TextureProgressBar = $CanvasLayer/StressBar

@export var _stress_inc_max: float = 1
@export var _stress_threshold: float = .75
@export var _day_time: float = 2400

var _stress_inc: float
var _stressing: bool

func _ready():
	Score.chore_running.connect(_pause)
	_progress.max_value = _day_time
	_progress.value = _progress.max_value
	await get_tree().process_frame
	await get_tree().create_timer(1).timeout
	_timer.start(_day_time)
	_timer.timeout.connect(_lose)

func _process(delta: float) -> void:
	_progress.value = _timer.time_left
	Score.stress += _stress_inc
	_stress.value = Score.stress
	var stress_ratio = _stress.value / _stress.max_value
	if !_stressing and stress_ratio > _stress_threshold:
		_stressing = true
		high_stress.emit(_stressing)
	elif _stressing and stress_ratio < _stress_threshold:
		_stressing = false
		high_stress.emit(_stressing)

func _chores_changed(count: int):
	#TODO: This is backwards, gets smaller with each chore
	# Maybe instead do different thing like just add to stress amount
	_stress_inc = _stress_inc_max * pow(.5, count)

func _lose():
	print("TIME UP")
	queue_free()

func _pause(pause: bool):
	_timer.paused = pause
	_progress.visible = !pause
