extends CharacterBody2D

@onready var MOVE_COMPONENT: MoveComponent = $MoveComponent as MoveComponent
@onready var SHIP_BODY: AnimatedSprite2D = $ShipBody
@onready var SHIP_TRAIL: AnimatedSprite2D = $ShipFlame
var player_ID : String
@export var ShipType : String
var SPEED = 150
func _ready():
	# Initialization code if needed
	pass

func _physics_process(delta):
	var input_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("P"+player_ID+"Left"):
		input_velocity.x = -1
	if Input.is_action_pressed("P"+player_ID+"Right"):
		input_velocity.x = 1
	if Input.is_action_pressed("P"+player_ID+"Up"):
		input_velocity.y = -1
	if Input.is_action_pressed("P"+player_ID+"Down"):
		input_velocity.y = 1
	
	position += input_velocity * SPEED * delta
	move_and_slide()#this method detects collision and prevents the player from clipping through the wall
	animate_the_ship(input_velocity)
	


func animate_the_ship(input_velocity) -> void:
	if input_velocity.x == 0 and input_velocity.y == 0:
		SHIP_BODY.play("center")
		SHIP_TRAIL.play("forwardCenter")
	elif input_velocity.x == 0:
		SHIP_BODY.play("center")
		if input_velocity.y < 0:
			SHIP_TRAIL.play("forwardCenter")
		else:
			SHIP_TRAIL.play("backwardsCenter")
	elif input_velocity.y == 0:
		if input_velocity.x < 0:
			SHIP_BODY.play("bank_left")
			SHIP_TRAIL.play("forwardLeft")
		else:
			SHIP_BODY.play("bank_right")
			SHIP_TRAIL.play("forwardRight")
	else:
		if input_velocity.x < 0:
			SHIP_BODY.play("bank_left")
			if input_velocity.y < 0:
				SHIP_TRAIL.play("forwardLeft")
			else:
				SHIP_TRAIL.play("backwardsLeft")
		else:
			SHIP_BODY.play("bank_right")
			if input_velocity.y < 0:
				SHIP_TRAIL.play("forwardRight")
			else:
				SHIP_TRAIL.play("backwardsRight")
