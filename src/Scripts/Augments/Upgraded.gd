extends Node

@onready var HEALTHCOMPONENT:HealthComponent = $"/root/Main/BaseShip/HealthComponent"
# Called when the node enters the scene tree for the first time.
func _ready():
	HEALTHCOMPONENT.HEALTH += 1 #should I update the player manager too?

