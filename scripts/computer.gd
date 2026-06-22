extends ProgressChore

@onready var _congrats: Label = $CanvasLayer/Congrats
@export var max_value: float = 8000
@export var start_amount: float = 8

# override chore.setup, don't stop day clock
func _setup():
	Score.update_chores.connect(chores_changed)
	chores_changed(Score.get_chores_length())
	_progress.max_value = max_value
	_progress.visible = false
	_congrats.visible = false
	_progress.value = Score.score

func _physics_process(delta: float) -> void:
	super(delta)
	Score.score = _progress.value

func chores_changed(count: int):
	amount = start_amount * (pow(.5, count))
	
func finish():
	_congrats.visible = true
