extends Node

@onready var _timer: Timer = $DayTimer
@onready var _progress: TextureProgressBar = $CanvasLayer/TextureProgressBar

@export var day_time: float = 2400

func _ready():
	Score.chore_running.connect(_pause)
	_progress.max_value = day_time
	_progress.value = _progress.max_value
	await get_tree().process_frame
	await get_tree().create_timer(1).timeout
	_timer.start(day_time)
	_timer.timeout.connect(_lose)

func _process(delta: float) -> void:
	_progress.value = _timer.time_left

func _lose():
	print("TIME UP")
	queue_free()

func _pause(pause: bool):
	_timer.paused = pause
	_progress.visible = !pause
