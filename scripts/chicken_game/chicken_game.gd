extends Subgame

@onready var _player: Player = $Trevor
@onready var _timer: Timer = $Timer
@onready var _progress: TextureProgressBar = $CanvasLayer/TextureProgressBar

@export var chicken_scene: PackedScene
@export var min_chickens: int = 1
@export var max_chickens: int = 2
@export var time: float = 20

var _chickens: Array[Node2D]

func _ready():
	_player.disabled = true
	await get_tree().create_timer(1).timeout
	for i in range(0, randi_range(min_chickens, max_chickens)):
		var instance = chicken_scene.instantiate() as Node2D
		_chickens.append(instance)
		add_child(instance)
		await get_tree().create_timer(.3).timeout
	_player.disabled = false
	_progress.max_value = time
	_timer.timeout.connect(func(): lose.emit())
	_timer.wait_time = time
	_timer.start()

func _process(delta: float) -> void:
	if _timer.is_stopped():
		return
	_progress.value = _timer.time_left

func _goal(body: Node2D):
	if body in _chickens:
		_chickens.remove_at(_chickens.find(body))
		body.queue_free.call_deferred()
	if _chickens.size() == 0:
		win.emit()
