class_name Being
extends CharacterBody2D

var size: int
var max_size: int = 100

var _nearby_beings: Array[Being]
var _seen_beings: Array[Being]
var direction: Vector2

func _area_entered(body: Node2D):
	if body is Being:
		_nearby_beings.append(body as Being)

func _area_exited(body: Node2D):
	if body is Being and body in _nearby_beings:
		_nearby_beings.remove_at(_nearby_beings.find(body as Being))

func _seen_entered(body: Node2D):
	if body is Being:
		_seen_beings.append(body as Being)

func _seen_exited(body: Node2D):
	if body is Being and body in _seen_beings:
		_seen_beings.remove_at(_seen_beings.find(body as Being))

func _physics_process(delta: float) -> void:
	size += 1
	if size >= max_size:
		_split()
	else:
		_think()
		move_and_slide()

func _think():
	pass

func _split():
	pass
