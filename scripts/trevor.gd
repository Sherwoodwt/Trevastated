extends CharacterBody2D


@export var SPEED = 300.0


func _physics_process(delta: float) -> void:
	var vel = Vector2.ZERO
	if Input.is_action_pressed("left"):
		vel.x = -SPEED
	if Input.is_action_pressed("right"):
		vel.x = SPEED
	if Input.is_action_pressed("up"):
		vel.y = -SPEED
	if Input.is_action_pressed("down"):
		vel.y = SPEED
	
	if vel.length() == 0:
		vel.x = move_toward(velocity.x, 0, SPEED)
	
	velocity = vel
	move_and_slide()
