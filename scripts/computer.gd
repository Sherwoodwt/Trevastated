extends Area2D

var _body: Node2D
@onready var _progress: TextureProgressBar = $CanvasLayer/ProgressBar
@onready var _congrats: Label = $CanvasLayer/Congrats

func _ready():
	_progress.visible = false
	_congrats.visible = false

func start(body: Node2D):
	if body.is_in_group("player"):
		_progress.visible = true
		_body = body

func stop(body: Node2D):
	if body.is_in_group("player"):
		_progress.visible = false
		_body = null

func _physics_process(delta: float) -> void:
	if (_body):
		Score.score += 1
		_progress.value = Score.score
	
	if _progress.value == _progress.max_value:
		_congrats.visible = true
