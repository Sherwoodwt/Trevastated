class_name ChoreData
extends Resource

@export var room_label: String
@export_file("*.tscn") var chore: String
@export var cooldown: float
@export_range(0, 1) var likelihood: float
@export var escalate_time: float
@export var stress_amount: float
@export var icon: Texture2D
