extends Node

@onready var BULLETINTERVAL : Timer = $"/root/Main/BaseShip/BulletInterval"
# Called when the node enters the scene tree for the first time.
func _ready():
	BULLETINTERVAL.wait_time -= 0.1
	if BULLETINTERVAL.wait_time <= 0.25:
		BULLETINTERVAL.wait_time = 0.25
	

