class_name Chore
extends Area2D

signal start
signal stop

@export var chore_data: ChoreData
var _body: Node2D

func _ready():
	body_entered.connect(enter)
	body_exited.connect(exit)

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
