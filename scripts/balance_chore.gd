class_name BalanceChore
extends Chore

@onready var _progress: TextureProgressBar = $CanvasLayer/ProgressBar
@onready var _balance: Balance = $CanvasLayer/Balance

func _ready():
	super()
	_progress.visible = false
	_balance.visible = false
	start.connect(_start)
	stop.connect(_stop)
	

func _setup():
	super()
	_progress.visible = false
	_balance.visible = false

func _start():
	_progress.visible = true
	_balance.start()

func _stop():
	_progress.visible = false
	_balance.visible = false

func _physics_process(delta: float) -> void:
	if (_body):
		_progress.value += 1
	
	if _progress.value == _progress.max_value:
		finish()

func finish():
	Score.remove_chore(chore_data)
	queue_free()
