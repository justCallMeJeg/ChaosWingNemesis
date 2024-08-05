extends Node

@onready var transAnimPlayer = $"../SceneTransition/TransAnimPlayer"
@onready var uiAnimationPlayer = $"../UIAnimationPlayer"

@onready var mainTitle = $"../MainText/MainTitle"
@onready var upperSubtitle = $"../MainText/UpperSubtitle"
@onready var lowerSubtitle = $"../MainText/LowerSubtitle"

@onready var sideSelectionIndicators = $"../SideSelectionIndicator"
# Enums for scene states
enum SelectionStages { SideSelect, ShipSelect, SceneSelect }
enum ShipSelectionDictionary { DEFAULT = -1, TOP, BOTTOM }

# Vars for various scene states
var disableP1Input: bool = true
var disableP2Input: bool = true
var P1ShipSelection: ShipSelectionDictionary = ShipSelectionDictionary.DEFAULT
var P2ShipSelection: ShipSelectionDictionary = ShipSelectionDictionary.DEFAULT
var isP1Selected: bool = false
var isP2Selected: bool = false

var P1SidePosition
var P2SidePosition
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ShipSelectionHandler ready!")

func _on_side_selection_handler_side_select_finished(_P1SidePosition, _P2SidePosition):
	P1SidePosition = _P1SidePosition
	P2SidePosition = _P2SidePosition
	stageIntroHandler()

func stageIntroHandler() -> void:	
	transAnimPlayer.play("SceneStageTransitionPart1")
	await transAnimPlayer.animation_finished
	sideSelectionIndicators.visible = false
	transAnimPlayer.play("SceneStageTransitionPart2")
	uiAnimationPlayer.play("ShipSelectionSceneIntro")
