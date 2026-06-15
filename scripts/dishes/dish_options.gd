extends Node

@export_dir var options: String = "res://things/dishes/options/"
@export_dir var boss_options: String = "res://things/dishes/options/bosses/"

var data = {}

func _ready():
	data["dishes"] = []
	for file in DirAccess.get_files_at(options):
		var res = load(options.path_join(file)) as PackedScene
		data["dishes"].append(res)
	data["bosses"] = []
	for file in DirAccess.get_files_at(boss_options):
		var res = load(boss_options.path_join(file)) as PackedScene
		data["bosses"].append(res)

func get_random_sprite(type: String) -> Texture2D:
	return (data[type] as Array[Texture2D]).pick_random()

func get_random_dish() -> PackedScene:
	return (data["dishes"] as Array[PackedScene]).pick_random()

func get_random_boss() -> PackedScene:
	return (data["bosses"] as Array[PackedScene]).pick_random()
