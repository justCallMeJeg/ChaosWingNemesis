extends Node

#@onready var SHOOTINGCOMPONENT:ShootingComponent = $"/root/Main/BaseShip/ShootingComponent"
@onready var main = get_tree().get_root().get_node("Main")
@onready var PLAYER_NAME : String = self.get_parent().get_parent().name

# Called when the node enters the scene tree for the first time.
func _ready():
	var SHOOTINGCOMPONENT : ShootingComponent = main.get_node(PLAYER_NAME).get_child(5)
	SHOOTINGCOMPONENT.BULLET_SIZE += 0.2


