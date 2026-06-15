extends Label

func _ready():
	Score.update_chores.connect(update_chores)

func update_chores(count: int):
	text = "Chores: %d" % count
