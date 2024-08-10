extends Control
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("anim")
	await animation_player.animation_finished
	SceneTransition.loadScene("res://src/Scenes/MainMenu.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE: # REMOVE THIS BEFORE RELEASE
			SceneTransition.loadScene("res://src/Scenes/MainMenu.tscn")
