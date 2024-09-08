extends Node

#@onready var BASESHIP =  $"/root/Main/BaseShip"
@onready var main = get_tree().get_root().get_node("Main")
@onready var PLAYER_NAME : CharacterBody2D = self.get_parent().get_parent()

var SCALE : float = 0.75
# Called when the node enters the scene tree for the first time.
func _ready():
	PLAYER_NAME.get_node("ShipBody").scale *= Vector2(SCALE,SCALE)
	PLAYER_NAME.get_node("ShipFlame").scale *= Vector2(SCALE,SCALE)
	PLAYER_NAME.get_node("ShipFlame").position += Vector2(SCALE,SCALE)
	PLAYER_NAME.get_node("Collision").scale *= Vector2(SCALE,SCALE)
	PLAYER_NAME.get_node("HitboxComponent").get_node("CollisionPolygon2D").scale *= Vector2(SCALE,SCALE)

