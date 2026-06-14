extends Node

signal update_chores(count: int)
signal chore_removed(chore: ChoreData)
signal chore_added(chore: ChoreData)

var score: int
var _chores: Array[ChoreData]

func add_chore(chore_data: ChoreData):
	_chores.append(chore_data)
	chore_added.emit(chore_data)
	update_chores.emit(_chores.size())

func remove_chore(chore_data: ChoreData):
	var i = _chores.find(chore_data)
	if i >= 0:
		_chores.remove_at(i)
		chore_removed.emit(chore_data)
		update_chores.emit(_chores.size())

func get_chores_length():
	return _chores.size()

func get_room_chores(room: String) -> Array[ChoreData]:
	return _chores.filter(func(c): return c.room_label == room)
