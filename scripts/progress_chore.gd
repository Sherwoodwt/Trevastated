class_name ProgressChore
extends Chore

@onready var _progress: TextureProgressBar = $CanvasLayer/ProgressBar
@export var amount: float = 1

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
	super(delta)
	if (_progress.visible):
		_progress.value += amount
	
	if _progress.value == _progress.max_value:
		finish()

func finish():
	Score.remove_chore(chore_data)
	queue_free()
