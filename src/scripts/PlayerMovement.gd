extends CharacterBody2D
@export var speed = 400
@onready var main = get_tree().get_root().get_node("TestNode")
@onready var projectile = load("res://src/scenes/bullet.tscn")

func _ready():
	shoot()
	

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.instantiatePosition = global_position
	instance.instantiateRotation = rotation
	instance.zIndex = z_index - 1
	main.add_child.call_deferred(instance)
	

func _on_cooldown_timeout():
	shoot()

func getInput():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	#rotation
	var look_vector = (get_global_mouse_position() - global_position).normalized()
	
	global_rotation = (atan2(look_vector.y, look_vector.x))+0.5 * PI
	
	
func _physics_process(_delta):
	getInput()
	move_and_slide()
	
	
