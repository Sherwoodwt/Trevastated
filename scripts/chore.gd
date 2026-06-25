class_name Chore
extends Area2D

signal start
signal stop

@export var chore_data: ChoreData
@export var _auto: bool
var _body: Node2D
var _overlapping: bool
var _started: bool

func _ready():
	body_entered.connect(enter)
	body_exited.connect(exit)
	_setup()

func _setup():
	start.connect(func(): _set_running(true))
	stop.connect(func(): _set_running(false))

func enter(body: Node2D):
	if !body.is_in_group("player"):
		return
	_overlapping = true
	_body = body

func exit(body: Node2D):
	if !body.is_in_group("player"):
		return
	_overlapping = false
	_body = null
	_started = false
	stop.emit()

func _physics_process(delta: float) -> void:
	if !_started and _overlapping and (_auto or Input.is_action_pressed("interact")):
		_started = true
		start.emit()

func _set_running(running: bool):
	Score.chore_running.emit(running)
