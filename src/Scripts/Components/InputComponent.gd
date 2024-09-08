#remove this and move component

class_name InputComponent
extends Node2D

@onready var MOVE_COMPONENT: MoveComponent = $"/root/Main/BaseShip/MoveComponent"
@export var SPEED: int = 100
var player_ID : String

#func _physics_process(delta):
#	var input_velocity = Vector2.ZERO
#	
#	if Input.is_action_pressed("P"+player_ID+"Left"):
#		input_velocity.x = -1
#	if Input.is_action_pressed("P"+player_ID+"Right"):
#		input_velocity.x = 1
#	if Input.is_action_pressed("P"+player_ID+"Up"):
#		input_velocity.y = -1
#	if Input.is_action_pressed("P"+player_ID+"Down"):
#		input_velocity.y = 1
#	
#	get_parent().position += input_velocity * SPEED * delta
#	get_parent().move_and_slide()

#func _input(event: InputEvent) -> void:
#	var leftRightAxis = Input.get_axis("P"+player_ID+"Left" , "P"+player_ID+"Right")
#	var topDownAxis = Input.get_axis("P"+player_ID+"Up", "P"+player_ID+"Down")
#	MOVE_COMPONENT.VELOCITY = Vector2(leftRightAxis * SPEED, topDownAxis * SPEED)
