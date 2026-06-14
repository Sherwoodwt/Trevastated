class_name ProgressChore
extends Chore

@onready var _progress: TextureProgressBar = $CanvasLayer/ProgressBar

func _ready():
	super()
	_progress.visible = false
	start.connect(_start)
	stop.connect(_stop)

func _start():
	_progress.visible = true

func _stop():
	_progress.visible = false

func _physics_process(delta: float) -> void:
	if (_body):
		_progress.value += 1
	
	if _progress.value == _progress.max_value:
		finish()

func finish():
	Score.remove_chore(chore_data)
	queue_free()
