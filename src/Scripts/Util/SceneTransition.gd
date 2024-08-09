extends ColorRect

@onready var anim = $AnimationPlayer

func _ready() -> void:
	# Plays the animation backward to fade in
	anim.play_backwards("fade")

func loadScene(_next_scene: StringName) -> void:
	# Plays the Fade animation and wait until it finishes
	anim.play("fade")
	await anim.animation_finished
	# Changes the scene
	get_tree().change_scene_to_file(_next_scene)
