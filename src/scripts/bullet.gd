extends CharacterBody2D

@export var SPEED = 100

var dir: float
var instantiatePosition : Vector2
var instantiateRotation : float
var zIndex : int


func _ready():
	global_position = instantiatePosition
	global_rotation = instantiateRotation
	z_index = zIndex
	
func _physics_process(_delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()


func _on_area_2d_body_entered(body):
	queue_free()
	print("HIT!!!")
	


func _on_life_timeout():
	queue_free()
