class_name Player
extends CharacterBody2D

@export var SPEED = 300.0

var disabled: bool

func _physics_process(delta: float) -> void:
	if disabled:
		return
	
	var vel = Vector2.ZERO
	if Input.is_action_pressed("left"):
		vel.x = -SPEED
	if Input.is_action_pressed("right"):
		vel.x = SPEED
	if Input.is_action_pressed("up"):
		vel.y = -SPEED
	if Input.is_action_pressed("down"):
		vel.y = SPEED
	
	velocity = vel
	move_and_slide()
