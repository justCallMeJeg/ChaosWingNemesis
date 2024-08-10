extends Node

@onready var BASESHIP =  $"/root/Main/BaseShip"
var SCALE : float = 0.75
# Called when the node enters the scene tree for the first time.
func _ready():
	BASESHIP.get_node("ShipBody").scale *= Vector2(SCALE,SCALE)
	BASESHIP.get_node("ShipFlame").scale *= Vector2(SCALE,SCALE)
	BASESHIP.get_node("ShipFlame").position += Vector2(SCALE,SCALE)
	BASESHIP.get_node("Collision").scale *= Vector2(SCALE,SCALE)
	BASESHIP.get_node("HitboxComponent").get_node("CollisionPolygon2D").scale *= Vector2(SCALE,SCALE)

