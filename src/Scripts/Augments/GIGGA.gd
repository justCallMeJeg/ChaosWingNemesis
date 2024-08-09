extends Node

@onready var SHOOTINGCOMPONENT:ShootingComponent = $"/root/Main/BaseShip/ShootingComponent"
# Called when the node enters the scene tree for the first time.
func _ready():
	SHOOTINGCOMPONENT.BULLET_SIZE = 0.3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
