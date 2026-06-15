class_name Dish
extends RigidBody2D

signal success
signal fail

@onready var sprite = $Sprite2D
@onready var arrow_box: HFlowContainer = $CanvasLayer/HFlowContainer

@onready var step_scene: PackedScene = load("res://things/dishes/arrow.tscn")
@export var sprite_options: Array[Texture2D]
@export var label: String
@export var min_steps: int
@export var max_steps: int

const MAP = ["up", "right", "down", "left"]

var steps: Array[Arrow]
var _cur: int
var _current: bool

func _ready():
	sprite.texture = sprite_options.pick_random()
	var step_count = randi_range(min_steps, max_steps)
	for i in range(0, step_count):
		var instance = step_scene.instantiate() as Arrow
		instance.direction = randi_range(0, 3)
		steps.append(instance)
		arrow_box.add_child(instance)
	arrow_box.visible = false

func _physics_process(delta: float) -> void:
	if !_current:
		return
	for i in range(0, MAP.size()):
		if Input.is_action_just_pressed(MAP[i]):
			var result = steps[_cur].attempt(i)
			if result:
				correct()
			else:
				wrong()

func start():
	_current = true
	position = Vector2.ZERO
	gravity_scale = 0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	arrow_box.visible = true

func correct():
	steps[_cur].success()
	_cur += 1
	if _cur >= steps.size():
		#TODO: Fling it here
		success.emit()
		queue_free()

func wrong():
	#TODO: break it here
	fail.emit()
	queue_free()
