extends ProgressChore

@onready var _congrats: Label = $CanvasLayer/Congrats
@export var max_value: float = 1000

func _ready():
	super()
	_setup()

func _setup():
	super()
	_progress.max_value = max_value
	_progress.visible = false
	_congrats.visible = false
	_progress.value = Score.score

func _physics_process(delta: float) -> void:
	if Score.get_chores_length() != 0:
		return
	super(delta)
	Score.score = _progress.value
	
func finish():
	_congrats.visible = true
