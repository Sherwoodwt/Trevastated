extends Node2D

@onready var dish_location: Node2D = $DishLocation
@onready var dish_spawner: Node2D = $DishSpawner
@onready var boss_spawner: Node2D = $BossSpawner
@onready var heart_box: HBoxContainer = $CanvasLayer/HBoxContainer
@onready var timer: Timer = $Timer
@onready var timer_progress: TextureProgressBar = $CanvasLayer/TextureProgressBar

const MIN_DISHES: int = 7
const MAX_DISHES: int = 12
const MAX_FAILS: int = 3

var dishes: Array[Dish]

var _current_dish: Dish
var _fails: int

func _ready():
	var dish_count = randi_range(MIN_DISHES, MAX_DISHES)
	timer_progress.max_value = timer.wait_time
	timer_progress.value = timer.wait_time
	for i in range(0, dish_count):
		var instance: Dish
		if i < dish_count - 1:
			instance = DishOptions.get_random_dish().instantiate()
			dish_spawner.add_child(instance)
			dishes.append(instance)
		else:
			instance = DishOptions.get_random_boss().instantiate()
			boss_spawner.add_child(instance)
			dishes.push_front(instance)
		await get_tree().create_timer(.3).timeout
	await get_tree().create_timer(1).timeout
	queue_dish()
	timer.start()

func _process(delta: float) -> void:
	if timer.is_stopped():
		return
	timer_progress.value = timer.time_left

func queue_dish():
	_current_dish = dishes.pop_back()
	if !_current_dish:
		print("victory")
		queue_free()
	else:
		_current_dish.reparent(dish_location)
		_current_dish.success.connect(queue_dish)
		_current_dish.fail.connect(fail)
		_current_dish.start()

func fail():
	_fails += 1
	if _fails >= MAX_FAILS:
		fail_game()
	else:
		heart_box.remove_child(heart_box.get_child(0))
		queue_dish()

func fail_game():
	print("FAILED")
	queue_free()
