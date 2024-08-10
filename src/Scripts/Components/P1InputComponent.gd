class_name P1InputComponent
extends Node

@onready var MOVE_COMPONENT : MoveComponent = $"/root/Main/BaseShip/MoveComponent"
@export var SPEED: int = 100

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("P1Left"):
		print("left")
	var leftRightAxis = Input.get_axis("P1Left", "P1Right")
	print(leftRightAxis)
	var topDownAxis = Input.get_axis("P1Up", "P1Down")
	MOVE_COMPONENT.VELOCITY = Vector2(leftRightAxis * SPEED, topDownAxis * SPEED)
