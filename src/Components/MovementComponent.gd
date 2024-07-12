extends Node2D

class_name MovementComponent

@export var speed: float = 200.0
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	velocity = velocity.normalized() * speed
	if owner:
		owner.move_and_slide(velocity)
