extends Node2D

@export var chore: ChoreData

func _ready():
	Score.chore_added.connect(func(c): chore_exists(c, true))
	Score.chore_removed.connect(func(c): chore_exists(c, false))

func chore_exists(c: ChoreData, exists: bool):
	if c == chore:
		visible = !exists
