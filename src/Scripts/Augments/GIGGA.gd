extends Node

@onready var SHOOTINGCOMPONENT:ShootingComponent = $"/root/Main/BaseShip/ShootingComponent"
# Called when the node enters the scene tree for the first time.
func _ready():
	SHOOTINGCOMPONENT.BULLET_SIZE = 0.3


