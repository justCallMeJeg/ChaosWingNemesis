extends Control

@onready var animPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer.play("idleLoop")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE: # REMOVE THIS BEFORE RELEASE
			print("pressed")
			SceneTransition.loadScene("res://src/Scenes/SelectionScene.tscn")
