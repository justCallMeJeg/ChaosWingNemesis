class_name Aim_ShootingComponent
extends Node2D

@export var ACTOR : Node2D

func _process(delta):
	var look_vector = (ACTOR.get_global_mouse_position() - ACTOR.global_position).normalized()
	ACTOR.global_rotation = (atan2(look_vector.y, look_vector.x))+0.5 * PI
	
	
	

