extends Node2D

const DIR_PATH: String = "res://resources/"

@onready var timer: Timer = $Timer
@export var min_time = 10
@export var max_time = 20
@export var max_chores = 10

var _chore_options: Array[ChoreData]

func _ready():
	timer.timeout.connect(_make_trouble)
	Score.chore_removed.connect(_reset_chore)
	start_random_timer()
	var files = ResourceLoader.list_directory(DIR_PATH)
	for file in files:
		var full_path = DIR_PATH.path_join(file)
		var resource = load(full_path)
		_chore_options.append(resource)

func start_random_timer():
	timer.start(randf_range(min_time, max_time))

func _make_trouble():
	if Score.get_chores_length() < max_chores:
		var randi = randi_range(0, _chore_options.size()-1)
		Score.add_chore(_chore_options[randi])
		_chore_options.remove_at(randi)

func _reset_chore(chore_data: ChoreData):
	if !_chore_options.any(func(c): c == chore_data):
		_chore_options.append(chore_data)
