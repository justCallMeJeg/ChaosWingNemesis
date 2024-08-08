extends Control
@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idleLoop")
	pass # Replace with function body.
