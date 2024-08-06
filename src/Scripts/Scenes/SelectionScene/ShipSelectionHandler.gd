extends Node

@onready var transAnimPlayer = $"../SceneTransition/TransAnimPlayer"
@onready var uiAnimationPlayer = $"../UIAnimationPlayer"

@onready var mainTitle = $"../MainText/MainTitle"
@onready var upperSubtitle = $"../MainText/UpperSubtitle"
@onready var lowerSubtitle = $"../MainText/LowerSubtitle"

@onready var sideSelectionIndicators = $"../SideSelectionIndicator"

@onready var topPlayerIndicator = $"../ShipSelectionIndicator/TopPlayerShipIndicator"
@onready var bottomPlayerIndicator = $"../ShipSelectionIndicator/BottomPlayerShipIndicator"

@onready var sfxPlayer = $"../SFXPlayer"

const CONFIRM_SFX = preload("res://src/Assets/Sound/UI/ConfirmSFX.wav")
const SELECT_SFX = preload("res://src/Assets/Sound/UI/SelectSFX.wav")

# Enums for scene states
enum SelectionStages { SideSelect, ShipSelect, SceneSelect }
enum SideSelectionPosition { TOP, BOTTOM }
enum ShipSelection { RAZOR, JUGGERNAUT, PHANTOM, CONSTRUCTOR }
var ShipSelectionDictionary = [
	preload("res://src/Assets/UI/SpaceshipIcons/RAZOR_UI.png"), # RAZOR
	preload("res://src/Assets/UI/SpaceshipIcons/JUGGERNAUT_UI.png"), # JUGGERNAUT
	preload("res://src/Assets/UI/SpaceshipIcons/PHANTOM_UI.png"), # PHANTOM
	preload("res://src/Assets/UI/SpaceshipIcons/CONSTRUCTOR_UI.png") # CONSTRUCTOR
]

# Vars for various scene states
var disableP1Input: bool = true
var disableP2Input: bool = true
var P1CurrentShipSelection: ShipSelection = ShipSelection.RAZOR
var P2CurrentShipSelection: ShipSelection = ShipSelection.RAZOR
var isP1Selected: bool = false
var isP2Selected: bool = false

var P1SidePosition: int
var P2SidePosition: int
var P1Indicator
var P2Indicator

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ShipSelectionHandler ready!")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if get_parent().CurrentSceneStage == SelectionStages.ShipSelect:
			handleShipSelection(event)
			#if isP1Selected and isP2Selected:
				#stageTransitionHandler()

func _on_side_selection_handler_side_select_finished(_P1SidePosition, _P2SidePosition):
	P1Indicator = topPlayerIndicator if _P1SidePosition == SideSelectionPosition.TOP else bottomPlayerIndicator
	P2Indicator = topPlayerIndicator if _P2SidePosition == SideSelectionPosition.TOP else bottomPlayerIndicator
	stageIntroHandler()

func stageIntroHandler() -> void:	
	transAnimPlayer.play("SceneStageTransitionPart1")
	await transAnimPlayer.animation_finished
	sideSelectionIndicators.visible = false
	transAnimPlayer.play("SceneStageTransitionPart2")
	uiAnimationPlayer.play("ShipSelectionSceneIntro")
	await uiAnimationPlayer.animation_finished
	disableP1Input = false
	disableP2Input = false

func handleShipSelection(event: InputEventKey) -> void:
	match event.keycode:
		KEY_A, KEY_D:
			handlePlayerInput(topPlayerIndicator, P1SidePosition, P1CurrentShipSelection, isP1Selected, "disableP1Input", event, KEY_A, KEY_D)
		KEY_SPACE:
			pass

func handlePlayerInput(
	indicator: Control,
	sidePosition: SideSelectionPosition,
	shipSelection: ShipSelection,
	isSelected: bool,
	inputDisabled: String,
	event: InputEventKey,
	keyLeft: int,
	keyRight: int
) -> void:
	if isSelected or get(inputDisabled):
		return
	var newShipSelection = shipSelectionInputHandler(indicator, sidePosition, shipSelection, event, keyLeft, keyRight)
	if indicator == topPlayerIndicator:
		P1CurrentShipSelection = newShipSelection
	else:
		P2CurrentShipSelection = newShipSelection

func shipSelectionInputHandler(indicator: Control, sidePosition: SideSelectionPosition, shipSelection: ShipSelection, event, keyLeft, keyRight) -> ShipSelection:
	match event.keycode:
		keyLeft:
			pressAnim(indicator, 0)
		keyRight:
			pressAnim(indicator, 1)
	return ShipSelection.RAZOR

# Plays a sound with a random pitch scale
func playSound(sound: AudioStream, min_pitch: float = 0.000, max_pitch: float = 0.000) -> void:
	sfxPlayer.stream = sound
	if min_pitch > 0 and max_pitch > 0:
		sfxPlayer.pitch_scale = RandomNumberGenerator.new().randf_range(min_pitch, max_pitch)
	sfxPlayer.play()

func pressAnim(indicator: Control, dir: int) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	var dirIndicator
	if dir == 0:
		dirIndicator = indicator.get_child(0).get_child(0)
	elif dir == 1:
		dirIndicator = indicator.get_child(0).get_child(2)
	
	tween.tween_property(dirIndicator, "modulate", Color("#ffffff00"), 0.3337).from(Color("#ffffff"))
	tween.tween_property(dirIndicator, "modulate", Color("#ffffff"), 0.3337).from(Color("#ffffff00"))
	playSound(SELECT_SFX)

func updateSelection(currentSelection: ShipSelection, updatedSelection) -> void:
	pass
