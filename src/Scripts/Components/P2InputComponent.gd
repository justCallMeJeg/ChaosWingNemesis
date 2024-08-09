class_name P2InputComponent
extends Node

@export var MOVE_COMPONENT: MoveComponent
@export var SPEED: int = 100

func _input(event: InputEvent) -> void:
	var leftRightAxis = Input.get_axis("P2Left", "P2Right")
	var topDownAxis = Input.get_axis("P2Up", "P2Down")
	MOVE_COMPONENT.VELOCITY = Vector2(leftRightAxis * SPEED, topDownAxis * SPEED)
