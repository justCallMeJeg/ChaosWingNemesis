extends Control

@onready var animationPlayer = $UIAnimationPlayer
@onready var SideSelectionHandler = $SideSelectionHandler
#@onready var ShipSelectionHandler = $ShipSelectionHandler
#@onready var SceneSelectionHandler = $SceneSelectionHandler
@onready var transAnimPlayer = $SceneTransition/TransAnimPlayer
@onready var textAnimPlayer = $MainText/TextAnimPlayer

# Enums for scene states
enum SelectionStages { SideSelect, ShipSelect, SceneSelect }
enum SideSelectionState { DEFAULT, TOP, BOTTOM }

# Vars for various scene states
@export var CurrentSceneStage: SelectionStages = SelectionStages.SideSelect

signal AnimationIntroFinished()

func _ready() -> void:
	transAnimPlayer.play("SceneStageTransitionPart1") # Plays SelectionStartIntro after scene ready
	await transAnimPlayer.animation_finished
	animationPlayer.play("SideSelectionSceneIntro") # Queue SideSelectionIntro after SelectionStartIntro
	transAnimPlayer.play("SceneStageTransitionPart2")
	await animationPlayer.animation_finished
	AnimationIntroFinished.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R: # REMOVE THIS BEFORE RELEASE
			get_tree().reload_current_scene() # REMOVE THIS BEFORE RELEASE

func setText() -> void:
	pass
