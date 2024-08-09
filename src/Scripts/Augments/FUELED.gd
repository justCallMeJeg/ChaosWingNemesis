extends Node

@onready var INPUTCOMPONENT : InputComponent = $"/root/Main/BaseShip/InputComponent"
# Called when the node enters the scene tree for the first time.
func _ready():
	INPUTCOMPONENT.SPEED += INPUTCOMPONENT.SPEED * 0.3


