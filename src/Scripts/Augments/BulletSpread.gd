extends Node

@onready var main = get_tree().get_root().get_node("Main")
@onready var PLAYER_NAME : String = self.get_parent().get_parent().name
func _ready():
	var SHOOTING_COMPONENT : ShootingComponent = main.get_node(PLAYER_NAME).get_child(5)
	SHOOTING_COMPONENT.BulletClass = "bulletSpread"

