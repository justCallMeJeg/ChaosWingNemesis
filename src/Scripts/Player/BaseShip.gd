extends Node2D

@onready var MOVE_COMPONENT: MoveComponent = $MoveComponent as MoveComponent
@onready var SHIP_BODY: AnimatedSprite2D = $ShipBody
@onready var SHIP_TRAIL: AnimatedSprite2D = $ShipFlame

func _ready():
	# Initialization code if needed
	pass

func _process(delta):
	animate_the_ship()

func animate_the_ship() -> void:
	var velocity = MOVE_COMPONENT.VELOCITY
	
	if velocity.x == 0 and velocity.y == 0:
		SHIP_BODY.play("center")
		SHIP_TRAIL.play("forwardCenter")
	elif velocity.x == 0:
		SHIP_BODY.play("center")
		if velocity.y < 0:
			SHIP_TRAIL.play("forwardCenter")
		else:
			SHIP_TRAIL.play("backwardsCenter")
	elif velocity.y == 0:
		if velocity.x < 0:
			SHIP_BODY.play("bank_left")
			SHIP_TRAIL.play("forwardLeft")
		else:
			SHIP_BODY.play("bank_right")
			SHIP_TRAIL.play("forwardRight")
	else:
		if velocity.x < 0:
			SHIP_BODY.play("bank_left")
			if velocity.y < 0:
				SHIP_TRAIL.play("forwardLeft")
			else:
				SHIP_TRAIL.play("backwardsLeft")
		else:
			SHIP_BODY.play("bank_right")
			if velocity.y < 0:
				SHIP_TRAIL.play("forwardRight")
			else:
				SHIP_TRAIL.play("backwardsRight")
