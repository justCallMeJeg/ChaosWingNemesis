class_name BulletComponent
extends CharacterBody2D

@export var BulletSpeed : float 


var dir : float
var instantiatePosition : Vector2
var instantiateRotation : float
var zIndex : int

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = instantiatePosition
	global_rotation = instantiateRotation
	z_index = zIndex
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2(0, -BulletSpeed).rotated(dir)
	move_and_slide()

func _on_area_2d_body_entered(body):
	queue_free()



func _on_despawn_timer_timeout():
	queue_free()
