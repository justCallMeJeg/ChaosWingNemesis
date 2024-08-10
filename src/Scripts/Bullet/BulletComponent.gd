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
	z_index = 9
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Vector2(0, -BulletSpeed).rotated(dir)
	move_and_slide()

func _on_area_2d_body_entered(_body):
	_body.get_node("HealthComponent").HEALTH -= 1
	_body.get_child(10).get_node("ProgressBar").value = _body.get_node("HealthComponent").HEALTH
	queue_free()#despawns when hitting a wall or an enemy
