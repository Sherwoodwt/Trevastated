extends Node

const DIR_PATH: String = "res://resources/"
enum { TIMER, COOLDOWN }

signal update_chores(count: int)
signal chore_removed(chore: ChoreData)
signal chore_added(chore: ChoreData)
signal chore_running(running: bool)

var score: int
var stress: float
var _chores: Array[ChoreData]

var timers: Dictionary = {}

func _ready():
	var files = ResourceLoader.list_directory(DIR_PATH)
	for file in files:
		var full_path = DIR_PATH.path_join(file)
		var resource = load(full_path) as ChoreData
		
		timers[resource.resource_name] = {}
		var timer: Timer = Timer.new()
		timer.name = "%s_timer" % resource.resource_name
		timers[resource.resource_name][TIMER] = timer
		timer.timeout.connect(_attempt.bind(resource))
		timer.wait_time = resource.escalate_time
		add_child(timer)
		timer.start()
		
		var cooldown: Timer = Timer.new()
		cooldown.name = "%s_cooldown" % resource.resource_name
		timers[resource.resource_name][COOLDOWN] = cooldown
		cooldown.timeout.connect(timer.start)
		cooldown.autostart = false
		cooldown.wait_time = resource.cooldown
		add_child(cooldown)

func add_chore(chore_data: ChoreData):
	_chores.append(chore_data)
	timers[chore_data.resource_name].TIMER.stop()
	for key in timers.keys():
		if key != chore_data.resource_name:
			# If one is added, all other timers reset
			timers[key].TIMER.start()
	chore_added.emit(chore_data)
	update_chores.emit(_chores.size())

func remove_chore(chore_data: ChoreData):
	var i = _chores.find(chore_data)
	if i >= 0:
		_chores.remove_at(i)
		_cooldown_chore(chore_data)
		chore_removed.emit(chore_data)
		update_chores.emit(_chores.size())

func get_chores_length():
	return _chores.size()

func get_room_chores(room: String) -> Array[ChoreData]:
	return _chores.filter(func(c): return c.room_label == room)

func _attempt(chore: ChoreData):
	var roll = randf()
	if roll <= chore.likelihood:
		add_chore(chore)

func _cooldown_chore(chore_data: ChoreData):
	var cooldown = timers[chore_data.resource_name].COOLDOWN as Timer
	cooldown.start()
