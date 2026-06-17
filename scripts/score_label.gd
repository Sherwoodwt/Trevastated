extends Label

@export var _text: String
@export var _source: Node
@export var _signal_name: String

func _ready():
	if !_source:
		_source = Score
	_source.connect(_signal_name, _update_label)

func _update_label(value: int):
	text = "%s: %d" % [_text, value]
