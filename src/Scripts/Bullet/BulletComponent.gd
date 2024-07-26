class_name BulletComponent
extends Node
@export var BulletSpeed : Vector2 
@export var ACTOR : Node2D

var dir : float
var instantiatePosition : Vector2
var instantiateRotation : float
var zIndex : int

# Called when the node enters the scene tree for the first time.
func _ready():
	ACTOR.global_position = instantiatePosition
	ACTOR.global_rotation = instantiateRotation
	zIndex = zIndex

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ACTOR.translate(BulletSpeed * delta)
	


func _on_area_2d_body_entered(body):
	ACTOR.queue_free()
	#print("HIT!!!")


func _on_timer_timeout():
	ACTOR.queue_free()
