extends Control

@onready var animationPlayer: AnimationPlayer = $SceneAnimationPlayer
@onready var SideSelectionHandler = $SideSelectionHandler
@onready var ShipSelectionHandler = $ShipSelectionHandler
@onready var SceneSelectionHandler = $SceneSelectionHandler

# Enums for scene states
enum SelectionStages { SideSelect, ShipSelect, SceneSelect }
enum SideSelectionState { DEFAULT, TOP, BOTTOM }

# Vars for various scene states
var CurrentSceneStage: SelectionStages = SelectionStages.SideSelect

signal SelectionSceneStageChanged(selectionSceneStage)
signal AnimationIntroFinished()

func _ready() -> void:
	animationPlayer.play("SelectionSceneStateTransition") # Plays SelectionStartIntro after scene ready
	animationPlayer.queue("SideSelectionIntro") # Queue SideSelectionIntro after SelectionStartIntro
	await animationPlayer.animation_finished
	AnimationIntroFinished.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R: # REMOVE THIS BEFORE RELEASE
			get_tree().reload_current_scene() # REMOVE THIS BEFORE RELEASE
