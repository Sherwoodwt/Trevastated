class_name Balance
extends Subgame

@onready var tilt: Tilt = $CanvasLayer/Control as Tilt
@onready var pointer: TextureRect = $CanvasLayer/Control/Panel/Pointer
@onready var background: TextureRect = $CanvasLayer/Control/Panel/Background
@onready var death_timer: Timer = $DeathTimer
@onready var win_progress: TextureProgressBar = $CanvasLayer/ProgressBar

@export var normal_background: Texture2D
@export var bad_background: Texture2D

const INC: float = .003
const BAL_INC: float = .002
const MAX_SPEED: float = .03
const MAX_DISTANCE: float = 256
const THRESHOLD: float = .1
const OUTER_THRESHOLD: float = .60

var _input: float
var _speed: float
var _balance: float # basically position
var _start_position: float
var _player: Player
var _failing: bool
var _dying: bool

func _ready():
	death_timer.timeout.connect(_lose)
	_start_position = pointer.position.x
	_player = get_tree().get_first_node_in_group("player") as Player
	_player.disabled = true
	win_progress.value = 0
	pointer.position.x = _start_position
	await get_tree().create_timer(1).timeout

func _physics_process(delta: float) -> void:
	_input = 0.0
	if Input.is_action_pressed("balance_left"):
		_input -= INC
	if Input.is_action_pressed("balance_right"):
		_input += INC
	
	var rand_accel: float
	if abs(_balance) > THRESHOLD:
		rand_accel = sign(_balance) * BAL_INC
	else:
		rand_accel = randf_range(-INC, INC)
	_speed = clampf(_speed + rand_accel + _input, -MAX_SPEED, MAX_SPEED)
	_balance = clampf(_balance + _speed, -1, 1)
	pointer.position.x = (_balance * MAX_DISTANCE) + _start_position
	
	# if outer, don't increment success time but don't deplete it, no fail timer
	if !_failing and abs(_balance) > OUTER_THRESHOLD:
		_failing = true
	if _failing and abs(_balance) <= OUTER_THRESHOLD:
		_failing = false
	
	# if at max, reset timer and start fail timer
	if !_dying and (_balance <= -1 or _balance >= 1):
		_dying = true
		win_progress.value = 0
		background.texture = bad_background
		death_timer.start()
	if _dying and (_balance > -1 and _balance < 1):
		_dying = false
		background.texture = normal_background
		death_timer.stop()
	
	if !_dying and !_failing:
		win_progress.value += 1
		if win_progress.value == win_progress.max_value:
			_win()

func _win():
	_player.disabled = false
	win.emit()

func _lose():
	_player.disabled = false
	lose.emit()
