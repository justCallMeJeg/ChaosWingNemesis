class_name P1InputComponent
extends Node

@export var MOVE_COMPONENT: MoveComponent
@export var SPEED: int = 100

func _input(event: InputEvent) -> void:
	var leftRightAxis = Input.get_axis("P1Left", "P1Right")
	var topDownAxis = Input.get_axis("P1Up", "P1Down")
	MOVE_COMPONENT.VELOCITY = Vector2(leftRightAxis * SPEED, topDownAxis * SPEED)
