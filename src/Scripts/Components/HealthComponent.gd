extends Node

@export var HITBOX_COMPONENT: Area2D
@export var HEALTH: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Node Signals for external functions/components
signal healthDeplete()
signal healthChaged()
