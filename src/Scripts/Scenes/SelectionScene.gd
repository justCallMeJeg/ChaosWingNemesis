extends Control

@onready var animation_player = $AnimationPlayer

func _ready() ->void:
	print("Scene Ready")
	animation_player.play("SelectionStartIntro")
	animation_player.queue("SideSelectionIntro")



func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
