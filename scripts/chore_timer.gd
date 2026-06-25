class_name ChoreTimer
extends TextureProgressBar

@onready var timer: Timer = $Timer
@onready var icon: TextureRect = $TextureRect

var chore: ChoreData

func _ready():
	timer.wait_time = chore.escalate_time
	max_value = timer.wait_time
	timer.timeout.connect(_escalate)
	timer.start()
	icon.texture = chore.icon
	Score.chore_running.connect(func(running = true): timer.paused = running)

func _escalate():
	Score.stress += chore.stress_amount

func _process(delta: float) -> void:
	value = timer.wait_time - timer.time_left
