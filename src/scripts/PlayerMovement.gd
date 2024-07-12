extends CharacterBody2D
@export var speed = 400

 
func getInput():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed


	
func _physics_process(_delta):
	getInput()
	move_and_slide()
