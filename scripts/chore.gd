class_name Chore
extends Area2D

signal setup
signal start
signal stop

@export var chore_data: ChoreData
var _body: Node2D

func _ready():
	body_entered.connect(enter)
	body_exited.connect(exit)
	setup.connect(_setup)
	Score.update_chores.connect(func(c: int): _check_active())
	visible = false
	_check_active()

func _check_active():
	if Score.is_active(chore_data):
		setup.emit()

func enter(body: Node2D):
	if body.is_in_group("player"):
		_body = body
		start.emit()

func exit(body: Node2D):
	if body.is_in_group("player"):
		_body = null
		stop.emit()

func _setup():
	visible = true
