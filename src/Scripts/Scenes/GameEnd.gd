extends Control
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("anim")
	await animation_player.animation_finished
	SceneTransition.loadScene("res://src/Scenes/MainMenu.tscn")
