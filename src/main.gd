extends CanvasLayer

const TERAN = preload("res://src/Scenes/GameBG/Teran.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var instance = TERAN.instantiate()
	add_child(instance)
	move_child(instance, 1)
