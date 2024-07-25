extends CanvasLayer

@onready var rect = $ColorRect
@onready var anim = $AnimationPlayer

func _ready():
	rect.visible = false

func loadScene(scene: String) -> void:
	anim.play("Fade")
	await anim.animation_finished()
	get_tree().change_scene_to_file(scene)
	anim.play_backwards("Fade")

func reloadScene() -> void: 
	anim.play("Fade")
	await anim.animation_finished()
	get_tree().reload_current_scene()
	anim.play_backwards("Fade")
