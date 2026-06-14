extends Node2D

@export var label: String

func _ready():
	var chore_data = Score.get_room_chores(label)
	for chore in chore_data:
		_add_chore(chore)
	Score.chore_added.connect(_add_chore)

func _add_chore(chore: ChoreData):
	if chore.room_label != label:
		return
	var instance = load(chore.chore).instantiate() as Node2D
	add_child(instance)
