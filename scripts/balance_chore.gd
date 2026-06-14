class_name BalanceChore
extends Chore

@onready var _progress: TextureProgressBar = $CanvasLayer/ProgressBar
@onready var _balance: Balance = $CanvasLayer/Balance

const START_DELAY: float = 1
var _going: bool

func _ready():
	super()
	_progress.visible = false
	_balance.visible = false
	_balance.failing.connect(_set_failing)
	start.connect(_start)
	stop.connect(_stop)
	
func _start():
	_progress.visible = true
	_balance.start()
	await get_tree().create_timer(START_DELAY).timeout
	_going = true

func _stop():
	_progress.visible = false
	_balance.stop()
	_going = false

func _physics_process(delta: float) -> void:
	if (_going):
		_progress.value += 1
	
	if _progress.value == _progress.max_value:
		finish()

func finish():
	Score.remove_chore(chore_data)
	queue_free()

func _set_failing(val: bool):
	_going = !val
	if !_going:
		_progress.value = 0
