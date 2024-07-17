class_name MoveComponent
extends Node

@export var ACTOR: Node2D
@export var VELOCITY: Vector2

func _process(delta:float ) -> void:
	ACTOR.translate(VELOCITY * delta)
	pass
