class_name InputComponent
extends Node

@export var MOVE_COMPONENT: MoveComponent
@export var SHOOT_COMPONENT: Aim_ShootingComponent
@export var MOVE_STATS: MovementStats

func _input(event: InputEvent) -> void:
	var left_right = Input.get_axis("ui_left", "ui_right")
	var top_down = Input.get_axis("ui_up", "ui_down")
	
	
	MOVE_COMPONENT.VELOCITY = Vector2(left_right * MOVE_STATS.SPEED, top_down * MOVE_STATS.SPEED)
