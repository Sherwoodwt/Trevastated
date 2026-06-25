extends CanvasLayer

@onready var _hover: Float = $PhoneButton/Float
@onready var _phone_button: Control = $PhoneButton
@onready var _phone: Panel = $Panel

func _toggle_hover(on: bool):
	_hover.enabled = on

func _toggle_enabled(on: bool):
	_phone_button.visible = !on
	_phone.visible = on
