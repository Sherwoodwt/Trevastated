class_name Door
extends Area2D

@export_file("*.tscn") var next_room_path: String
@export var label: String
@export var inverse: String
@export var direction: Vector2
@onready var room = $".."

func go_through(body: Node2D):
	if body.is_in_group("player"):
		var next_room = load(next_room_path).instantiate() as Node2D
		var doors = next_room.get_children(true).filter(func(c):
			var r = c as Door
			if r:
				return r.label == inverse
		)
		var door = doors.front()
		var player = get_tree().get_first_node_in_group("player")
		player.position = door.position + (door.direction * 96)
		room.add_sibling.call_deferred(next_room)
		room.queue_free()
