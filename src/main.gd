extends CanvasLayer

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer

const TERAN = preload("res://src/Scenes/GameScenes/Teran.tscn")
const HORIZON = preload("res://src/Scenes/GameScenes/Horizon.tscn")
const HORIZON_MUSIC = preload("res://src/Assets/Sound/BG/HORIZON.ogg")
const TERAN_MUSIC = preload("res://src/Assets/Sound/BG/TERAN.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	var instance
	if RandomNumberGenerator.new().randi_range(0, 1) == 0:
		instance = TERAN.instantiate()
		audioPlayer.stream = TERAN_MUSIC
		audioPlayer.play()
	else:
		instance = HORIZON.instantiate()
		audioPlayer.stream = HORIZON_MUSIC
		audioPlayer.play()
	add_child(instance)
	move_child(instance, 1)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R: # REMOVE THIS BEFORE RELEASE
			get_tree().reload_current_scene() # REMOVE THIS BEFORE RELEASE
