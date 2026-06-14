class_name Balance
extends Control

signal failing(val: bool)

@onready var pointer: TextureRect = $Panel/Pointer
@onready var background: TextureRect = $Panel/Background

@export var normal_background: Texture2D
@export var bad_background: Texture2D

const INC: float = .35
const MAX_SPEED: float = 10
const MAX_DISTANCE: float = 256

var _input: float
var _speed: float
var _start_position: float
var _player: Player
var _failing: bool

func _ready():
	_start_position = pointer.position.x
	_player = get_tree().get_first_node_in_group("player") as Player

func _physics_process(delta: float) -> void:
	_input = 0.0
	if Input.is_action_pressed("balance_left"):
		_input -= INC
	if Input.is_action_pressed("balance_right"):
		_input += INC
	
	_speed += _input
	var sign = signf(_speed)
	if absf(_speed) > MAX_SPEED:
		_speed = MAX_SPEED * sign
	
	var pos = pointer.position.x + _speed
	var min = _start_position - MAX_DISTANCE
	var max = _start_position + MAX_DISTANCE
	
	if !_failing and (pos < min or pos > max):
		_failing = true
		failing.emit(_failing)
	if _failing and (pos >= min and pos <= max):
		_failing = false
		failing.emit(_failing)
	pointer.position.x = clampf(pos, min, max)
	if abs(pointer.position.x - _start_position) > (MAX_DISTANCE * .75):
		background.texture = bad_background
	else:
		background.texture = normal_background

func start():
	visible = true
	_player.disabled = true

func stop():
	visible = false
	_player.disabled = false
