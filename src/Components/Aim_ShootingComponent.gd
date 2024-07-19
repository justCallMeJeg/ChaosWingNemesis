class_name Aim_ShootingComponent
extends Node

@onready var main = get_tree().get_root().get_node("Main")#Creating bullet outside of the Player node to separate the bullet's position from the player's
@onready var projectile = load("res://src/Player/bullet.tscn")
@export var ACTOR : Node2D

@export var shootingInterval: float
var canFire = true

func _process(delta):
	var look_vector = (ACTOR.get_global_mouse_position() - ACTOR.global_position).normalized()
	ACTOR.global_rotation = (atan2(look_vector.y, look_vector.x))+0.5 * PI
	
	if Input.is_action_pressed("attack") and canFire:
		shoot()
		canFire = false
		await get_tree().create_timer(shootingInterval).timeout
		canFire = true
	

func shoot():
	var instance = projectile.instantiate()
	instance.dir = ACTOR.rotation
	instance.instantiatePosition = ACTOR.global_position
	instance.instantiateRotation = ACTOR.rotation
	instance.zIndex = ACTOR.z_index - 1
	main.add_child.call_deferred(instance)

