extends Node

@export var chore_timer_scene: PackedScene

var chores: Array[ChoreTimer]

func _ready():
	Score.chore_added.connect(add_chore)
	Score.chore_removed.connect(remove_chore)

func add_chore(chore: ChoreData):
	var instance = chore_timer_scene.instantiate() as ChoreTimer
	instance.chore = chore
	chores.append(instance)
	add_child(instance)
	move_child(instance, 0 )

func remove_chore(chore: ChoreData):
	for c in chores:
		if c.chore == chore:
			chores.remove_at(chores.find(c))
			c.queue_free()
 
