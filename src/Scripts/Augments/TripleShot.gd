extends Node

@onready var main = get_tree().get_root().get_node("Main")
var PLAYER_ID : String
func _ready():
	PLAYER_ID = self.get_parent().get_parent().name
	var SHOOTING_COMPONENT : ShootingComponent = main.get_node(PLAYER_ID).get_child(5)
	SHOOTING_COMPONENT.BulletSpread = true
	print(PLAYER_ID)
	
	

