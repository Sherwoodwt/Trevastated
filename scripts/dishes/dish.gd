class_name Dish
extends RigidBody2D

signal success
signal fail

@onready var sprite:Sprite2D = $Sprite2D
@onready var arrow_box: HFlowContainer = $CanvasLayer/HFlowContainer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var break_sound: AudioStreamPlayer2D = $break_sound
@onready var succeed_sound: AudioStreamPlayer2D = $succeed_sound
@onready var hit_ground_sound: AudioStreamPlayer2D = $hit_ground_sound

const WAIT_TIME: float = .8

@onready var step_scene: PackedScene = load("res://things/dishes/arrow.tscn")
@export var broken_texture: Texture2D
@export var sprite_options: Array[Texture2D]
@export var label: String
@export var min_steps: int
@export var max_steps: int

const MAP = ["up", "right", "down", "left"]

var steps: Array[Arrow]
var _cur: int
var _current: bool
var _has_landed: bool
var _done: bool

func _ready():
	body_entered.connect(landed)
	sprite.texture = sprite_options.pick_random()
	var step_count = randi_range(min_steps, max_steps)
	for i in range(0, step_count):
		var instance = step_scene.instantiate() as Arrow
		instance.direction = randi_range(0, 3)
		steps.append(instance)
		arrow_box.add_child(instance)
	arrow_box.visible = false

func _physics_process(delta: float) -> void:
	if !_current || _done:
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
	steps[_cur].set_current()

func correct():
	steps[_cur].success()
	_cur += 1
	
	if _cur < steps.size():
		steps[_cur].set_current()
	else:
		success.emit()
		_done = true
		collision.disabled = true
		await get_tree().create_timer(2).timeout
		queue_free()

func wrong():
	_done = true
	sprite.texture = broken_texture
	break_sound.play()
	await get_tree().create_timer(WAIT_TIME).timeout
	fail.emit()
	queue_free()

func landed(node: Node):
	if _has_landed:
		return
	hit_ground_sound.play()
	_has_landed = true
