extends Node

@onready var INPUT_COMPONENT : InputComponent = $"/root/Main/BaseShip/InputComponent"

# Called when the node enters the scene tree for the first time.
func _ready():
	INPUT_COMPONENT.SPEED += INPUT_COMPONENT.SPEED * 0.3
	


