extends SubViewport

@export var being_scene: PackedScene

const MAX_BEINGS: int = 128

var _beings: Array[Node2D]

func add_being():
	if _beings.size() >= MAX_BEINGS:
		return
	
	var x = randf_range(0, size.x)
	var y = randf_range(0, size.y)
	var instance = being_scene.instantiate() as Node2D
	instance.position = Vector2(x, y)
	_beings.append(instance)
	add_child(instance)
