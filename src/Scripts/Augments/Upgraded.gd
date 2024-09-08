extends Node

#@onready var HEALTHCOMPONENT:HealthComponent = $"/root/Main/BaseShip/HealthComponent"
@onready var main = get_tree().get_root().get_node("Main")
@onready var PLAYER_NAME : String = self.get_parent().get_parent().name
# Called when the node enters the scene tree for the first time.
func _ready():
	var HEALTHCOMPONENT : HealthComponent = main.get_node(PLAYER_NAME).get_child(4)
	HEALTHCOMPONENT.HEALTH += 1 #should I update the player manager too?

