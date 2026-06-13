extends Node2D

@onready var timer: Timer = $Timer
@export var min_time = 10
@export var max_time = 20
@export var max_chores = 1
@export var chore_options: Array[ChoreData]

func _ready():
	timer.timeout.connect(_make_trouble)
	start_random_timer()

func start_random_timer():
	timer.start(randf_range(min_time, max_time))

func _make_trouble():
	if Score.get_chores_length() < max_chores:
		var randi = randi_range(0, chore_options.size()-1)
		Score.add_chore(chore_options[randi])
