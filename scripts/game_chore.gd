class_name GameChore
extends Chore

@onready var viewport: SubViewport = $CanvasLayer/SubViewportContainer/SubViewport
@onready var canvas: CanvasLayer = $CanvasLayer

@export var game_scene: PackedScene
var _player: Player
var _chore_factory: ChoreFactory
var _game: Node

func _ready():
	super()
	_player = get_tree().get_first_node_in_group("player") as Player
	canvas.visible = false
	start.connect(_on_start)
	stop.connect(_on_stop)
	monitoring = false
	await get_tree().physics_frame
	monitoring = true

func _on_start():
	_player.disabled = true
	_game = game_scene.instantiate() as Subgame
	_game.win.connect(_succeed)
	_game.lose.connect(_fail)
	canvas.visible = true
	viewport.add_child.call_deferred(_game)

func _on_stop():
	_player.disabled = false
	Score.remove_chore(chore_data)
	queue_free()

func _succeed():
	print("success")
	_on_stop()

func _fail():
	print("fail")
