extends Node2D

@export var label: String

func _ready():
	#Score.update_chores.connect(func(c: int): _check_active())
