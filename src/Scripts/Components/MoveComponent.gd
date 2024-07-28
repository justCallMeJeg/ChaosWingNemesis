class_name MoveComponent
extends Node

@export var ACTOR: Node2D
@export var VELOCITY: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ACTOR.translate(VELOCITY * delta)
	
