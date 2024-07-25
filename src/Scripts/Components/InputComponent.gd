class_name InputComponent
extends Node

@export var MOVE_COMPONENT: MoveComponent
@export var SPEED: int = 100

func _input(event: InputEvent) -> void:
	var leftRightAxis = Input.get_axis("ui_left", "ui_right")
	var topDownAxis = Input.get_axis("ui_up", "ui_down")
	MOVE_COMPONENT.VELOCITY = Vector2(leftRightAxis * SPEED, topDownAxis * SPEED)
