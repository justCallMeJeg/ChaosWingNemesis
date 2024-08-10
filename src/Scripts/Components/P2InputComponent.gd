class_name P2InputComponent
extends Node

@onready var MOVE_COMPONENT : MoveComponent = $"/root/Main/BaseShip/MoveComponent"
@export var SPEED: int = 100

func _input(event: InputEvent) -> void:
	var leftRightAxis = Input.get_axis("P2Left", "P2Right")
	var topDownAxis = Input.get_axis("P2Up", "P2Down")
	MOVE_COMPONENT.VELOCITY = Vector2(leftRightAxis * SPEED, topDownAxis * SPEED)
