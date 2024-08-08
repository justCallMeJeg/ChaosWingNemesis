extends Node2D

@export var speedOffset: float = 0.001

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += position.y * speedOffset


func _on_visible_on_screen_notifier_2d_screen_exited():
	position.y = -170
