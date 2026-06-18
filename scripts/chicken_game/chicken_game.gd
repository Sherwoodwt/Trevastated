extends Subgame

@onready var _timer: Timer = $Timer
@onready var _squirrel_timer: Timer = $SquirrelTimer
@onready var _progress: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var _squirrel_spawns: Array[Node2D]
@onready var _player: Player = $Player

@export var chicken_scene: PackedScene
@export var squirrel_scene: PackedScene
@export var min_chickens: int = 1
@export var max_chickens: int = 2
@export var time: float = 20
@export var min_squirrel_time: float = 2
@export var max_squirrel_time: float = 5
@export var squirrel_life: float = 5
@export var squirrel_speed: float = 500

var _chickens: Array[Node2D]

func _ready():
	_player.disabled = true
	await get_tree().create_timer(1).timeout
	for i in range(0, randi_range(min_chickens, max_chickens)):
		var instance = chicken_scene.instantiate() as Node2D
		_chickens.append(instance)
		add_child(instance)
		await get_tree().create_timer(.3).timeout
	_progress.max_value = time
	_player.disabled = false
	_timer.timeout.connect(func(): lose.emit())
	_timer.wait_time = time
	_timer.start()
	_squirrel_spawns.assign($SquirrelSpawns.get_children())
	_squirrel_timer.timeout.connect(_spawn_squirrel)
	_reset_squirrel_time()

func _process(delta: float) -> void:
	if _timer.is_stopped():
		return
	_progress.value = _timer.time_left

func _spawn_squirrel():
	_squirrel_timer.stop()
	var spawn = _squirrel_spawns.pick_random()
	var instance = squirrel_scene.instantiate() as MoveConstant
	instance.global_position = spawn.global_position
	instance.velocity = -instance.position.normalized()
	instance.velocity = instance.velocity.rotated(deg_to_rad(randf_range(-30, 30))) * squirrel_speed
	add_child(instance)
	get_tree().create_timer(squirrel_life).timeout.connect(func(): _kill_squirrel(instance))

func _kill_squirrel(squirrel: Node2D):
	squirrel.queue_free()
	_reset_squirrel_time()

func _reset_squirrel_time():
	_squirrel_timer.wait_time = randf_range(min_squirrel_time, max_squirrel_time)
	_squirrel_timer.start()

func _goal(body: Node2D):
	if body in _chickens:
		_chickens.remove_at(_chickens.find(body))
		body.queue_free.call_deferred()
	if _chickens.size() == 0:
		win.emit()
