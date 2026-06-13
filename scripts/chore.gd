class_name Chore
extends Area2D

@export var chore_data: ChoreData
var _body: Node2D

func _ready():
	body_entered.connect(enter)
	body_exited.connect(exit)
	Score.update_chores.connect(func(c: int): _check_active())
	visible = false
	_check_active()

func _check_active():
	if Score.is_active(chore_data):
		init()

func enter(body: Node2D):
	if body.is_in_group("player"):
		_body = body
		start()

func exit(body: Node2D):
	if body.is_in_group("player"):
		_body = null
		stop()

func init():
	visible = true

# extendable functions
func start():
	pass

func stop():
	pass
