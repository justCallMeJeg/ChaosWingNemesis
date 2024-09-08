extends Node

#@onready var INPUT_COMPONENT : InputComponent = $"/root/Main/BaseShip/InputComponent"
@onready var main = get_tree().get_root().get_node("Main")
@onready var PLAYER_NAME : String = self.get_parent().get_parent().name

# Called when the node enters the scene tree for the first time.
func _ready():
	var INPUT_COMPONENT : InputComponent = main.get_node(PLAYER_NAME).get_child(3)
	INPUT_COMPONENT.SPEED += INPUT_COMPONENT.SPEED * 0.3
	


