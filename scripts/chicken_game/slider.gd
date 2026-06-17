extends Area2D

@export var _body: CharacterBody2D
@export var _speed: float = 800
@export var _decay: float = 5

var _sliding: bool
var _motion: Vector2

func _ready():
	body_entered.connect(slide)

func slide(body: Node2D):
	if body is not CharacterBody2D:
		return
	var pusher = body as CharacterBody2D
	_sliding = true
	_body.set_physics_process(false)
	var dir = (pusher.velocity.normalized() + (_body.global_position - pusher.global_position).normalized()).normalized()
	_motion = dir * _speed
	# initial push to avoid overlap
	_body.global_position += _motion.normalized() * 10

func _physics_process(delta: float) -> void:
	if !_sliding:
		return
	
	var collision = _body.move_and_collide(_motion * delta)
	_motion += -_motion.normalized() * _decay
	if collision:
		_motion = _motion.bounce(collision.get_normal())
	if _motion.length() < _decay:
		_motion = Vector2.ZERO
	if _motion.length() == 0:
		_sliding = false
		_body.set_physics_process(true)
	
