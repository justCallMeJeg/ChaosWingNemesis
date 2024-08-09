extends Node

@onready var BASESHIP =  $"/root/Main/BaseShip"

# Called when the node enters the scene tree for the first time.
func _ready():
	BASESHIP.get_node("ShipBody").scale *= Vector2(0.5,0.5)
	BASESHIP.get_node("ShipFlame").scale *= Vector2(0.5,0.5)
	BASESHIP.get_node("Collision").scale *= Vector2(0.5,0.5)
	BASESHIP.get_node("HitboxComponent").get_node("CollisionPolygon2D").scale *= Vector2(0.5,0.5) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
