extends Node2D

@export var label: String

var _active_chores: Array[ChoreData]

func _ready():
	Score.chore_added.connect(_chore_added)
	Score.chore_removed.connect(_chore_removed)
	var chore_datas = Score.get_room_chores(label)
	for chore in chore_datas:
		_chore_added(chore)

func _chore_added(chore: ChoreData):
	if chore.room_label != label:
		return
	_active_chores.append(chore)
	var instance = load(chore.chore).instantiate() as Node2D
	add_child(instance)

func _chore_removed(chore: ChoreData):
	if chore in _active_chores:
		_active_chores.remove_at(_active_chores.find(chore))
