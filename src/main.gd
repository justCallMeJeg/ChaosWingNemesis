extends CanvasLayer

const TERAN = preload("res://src/Scenes/GameScenes/Teran.tscn")
const HORIZON = preload("res://src/Scenes/GameScenes/Horizon.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var instance
	if RandomNumberGenerator.new().randi_range(0, 1) == 0:
		instance = TERAN.instantiate()
	else:
		instance = HORIZON.instantiate()
	add_child(instance)
	move_child(instance, 1)
