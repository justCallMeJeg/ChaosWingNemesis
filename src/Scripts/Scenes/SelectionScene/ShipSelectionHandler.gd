extends Node

@onready var transAnimPlayer = $"../SceneTransition/TransAnimPlayer"
@onready var uiAnimationPlayer = $"../UIAnimationPlayer"

@onready var mainTitle = $"../MainText/MainTitle"
@onready var upperSubtitle = $"../MainText/UpperSubtitle"
@onready var lowerSubtitle = $"../MainText/LowerSubtitle"

@onready var sideSelectionIndicators = $"../SideSelectionIndicator"

@onready var leftBorderText = $"../BorderUI/LeftBorderColor/LeftBorderTexture/LeftBorderContainer/LeftMarginContainer/LeftBorderText"
@onready var rightBorderText = $"../BorderUI/RightBorderColor/RightBorderTexture/RightBorderContainer/RightMarginContainer/RightBorderText"

@onready var topTooltip = $"../TooltipUI/TopTooltipContainer/MarginContainer/TopTooltipText"
@onready var bottomTooltip = $"../TooltipUI/BottomTooltipContainer/MarginContainer/BottomTooltipText"

@onready var topPlayerIndicator = $"../ShipSelectionIndicator/TopPlayerShipIndicator"
@onready var bottomPlayerIndicator = $"../ShipSelectionIndicator/BottomPlayerShipIndicator"

@onready var topTextureTextShineGradient = $"../BGTextTexture/TopTextureTextContainer/TopTextureText/TopTextureTextShineGradient"
@onready var bottomTextureTextShineGradient = $"../BGTextTexture/CenterTextureContainer/CenterTextureText/CenterTextureTextShineGradient"

@onready var playerReadyIndicatorParent = $"../PlayerReadyIndicator"

@onready var leftBorderAnimPlayer = $"../BorderUI/LeftBorderColor/BorderAnimPlayer"
@onready var rightBorderAnimPlayer = $"../BorderUI/RightBorderColor/BorderAnimPlayer"

@onready var sfxPlayer = $"../SFXPlayer"

const CONFIRM_SFX = preload("res://src/Assets/Sound/UI/ConfirmSFX.wav")
const SELECT_SFX = preload("res://src/Assets/Sound/UI/SelectSFX.wav")

# Enums for scene states
enum SelectionStages { SideSelect, ShipSelect, SceneSelect }
enum SideSelectionPosition { TOP, BOTTOM }
enum ShipSelection { RAZOR, JUGGERNAUT, PHANTOM, CONSTRUCTOR }
var ShipSelectionData = [
	{
		"name": "RAZOR",
		"type": "INTERCEPTOR"
	},
	{
		"name": "JUGGERNAUT",
		"type": "BOMBER"
	},
	{
		"name": "PHANTOM",
		"type": "SNIPER"
	},
	{
		"name": "CONSTRUCTOR",
		"type": "ENGINEER"
	}
]

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

var P1SidePosition: SideSelectionPosition
var P2SidePosition: SideSelectionPosition
var P1Indicator
var P2Indicator

signal ShipSelectionFinished(P1ShipSelection, P2ShipSelection)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ShipSelectionHandler ready!")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if get_parent().CurrentSceneStage == SelectionStages.ShipSelect:
			handleShipSelection(event)
			if isP1Selected and isP2Selected:
				stageTransitionHandler()

func _on_side_selection_handler_side_select_finished(_P1SidePosition, _P2SidePosition):
	P1SidePosition = _P1SidePosition
	P2SidePosition = _P2SidePosition
	P1Indicator = topPlayerIndicator if _P1SidePosition == SideSelectionPosition.TOP else bottomPlayerIndicator
	P2Indicator = topPlayerIndicator if _P2SidePosition == SideSelectionPosition.TOP else bottomPlayerIndicator
	stageIntroHandler()

func stageIntroHandler() -> void:	
	updateSelection(P1Indicator, ShipSelection.RAZOR)
	updateSelection(P2Indicator, ShipSelection.RAZOR)
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
			handlePlayerInput(P1Indicator, P1SidePosition, P1CurrentShipSelection, isP1Selected, "disableP1Input", event, KEY_A, KEY_D)
		KEY_LEFT, KEY_RIGHT:
			handlePlayerInput(P2Indicator, P2SidePosition, P2CurrentShipSelection, isP2Selected, "disableP2Input", event, KEY_LEFT, KEY_RIGHT)
		KEY_SPACE:
			handlePlayerSelection(P1SidePosition, isP1Selected, "disableP1Input", P1Indicator, P1SelectedHandler)
		KEY_ENTER:
			handlePlayerSelection(P2SidePosition, isP2Selected, "disableP2Input", P2Indicator, P2SelectedHandler)

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
	if indicator == P1Indicator:
		P1CurrentShipSelection = newShipSelection
	else:
		P2CurrentShipSelection = newShipSelection

func handlePlayerSelection(
	sidePosition: SideSelectionPosition,
	isSelected: bool,
	inputDisabled: String,
	indicator: Control,
	selectionHandler: Callable
) -> void:
	if isSelected or get(inputDisabled):
		return
	else:
		selectionHandler.call()

func shipSelectionInputHandler(indicator: Control, sidePosition: SideSelectionPosition, shipSelection: ShipSelection, event, keyLeft, keyRight) -> ShipSelection:
	match event.keycode:
		keyLeft:
			if shipSelection == ShipSelection.RAZOR:
				shipSelection = ShipSelection.CONSTRUCTOR
			else:
				shipSelection -= 1
			pressAnim(indicator, 0)
			updateSelection(indicator, shipSelection)
		keyRight:
			if shipSelection == ShipSelection.CONSTRUCTOR:
				shipSelection = ShipSelection.RAZOR
			else:
				shipSelection += 1
			pressAnim(indicator, 1)
			updateSelection(indicator, shipSelection)
	return shipSelection

# Plays a sound with a random pitch scale
func playSound(sound: AudioStream, min_pitch: int = 0, max_pitch: int = 0) -> void:
	sfxPlayer.stream = sound
	if min_pitch > 0 and max_pitch > 0:
		sfxPlayer.pitch_scale = RandomNumberGenerator.new().randi_range(min_pitch, max_pitch)
	sfxPlayer.play()

func pressAnim(indicator: Control, dir: int) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	var dirIndicator
	if dir == 0:
		dirIndicator = indicator.get_child(0).get_child(0)
	elif dir == 1:
		dirIndicator = indicator.get_child(0).get_child(2)
	
	tween.tween_property(dirIndicator, "modulate", Color("#ffffff00"), 0.1337).from(Color("#ffffff"))
	tween.tween_property(dirIndicator, "modulate", Color("#ffffff"), 0.1337).from(Color("#ffffff00"))
	playSound(SELECT_SFX)

func updateSelection(indicatorParent: Control, currentSelection: ShipSelection) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	var shipSprite = indicatorParent.get_child(0).get_child(1)
	var shipText = indicatorParent.get_child(1).get_child(0)
	var shipType = indicatorParent.get_child(1).get_child(1)
	shipSprite.texture = ShipSelectionDictionary[currentSelection]
	shipText.text = ShipSelectionData[currentSelection].name
	shipType.text = ShipSelectionData[currentSelection].type
	tween.tween_property(shipText, "modulate", Color("#ffffff"), 0.1337).from(Color("#ffffff00"))
	tween.tween_property(shipType, "modulate", Color("#ffffff"), 0.1337).from(Color("#ffffff00"))
	pass

func P1SelectedHandler() -> void:
	isP1Selected = shipSelectedIndicatorHandler(P1SidePosition)
	disableP1Input = true
	leftBorderText.text = "PLAYER 1 READY!"
	updateTooltipAndPlaySound(P1SidePosition, "Waiting for Player 2...")
	bgTextTextureShineAnim(P1SidePosition)
	hideChoiceIndicator(P1Indicator.get_child(0))
	leftBorderAnimPlayer.play("PlayerReadyState")

func P2SelectedHandler() -> void:
	isP2Selected = shipSelectedIndicatorHandler(P2SidePosition)
	disableP2Input = true
	rightBorderText.text = "PLAYER 2 READY!"
	updateTooltipAndPlaySound(P2SidePosition, "Waiting for Player 1...")
	bgTextTextureShineAnim(P2SidePosition)
	hideChoiceIndicator(P2Indicator.get_child(0))
	rightBorderAnimPlayer.play("PlayerReadyState")

# Updates tooltip text and plays the selection sound effect
func updateTooltipAndPlaySound(selectionState: SideSelectionPosition, waitingText: String) -> void:
	var selectedSide = topTooltip if selectionState == SideSelectionPosition.TOP else bottomTooltip
	selectedSide.text = waitingText
	playSound(CONFIRM_SFX, 0, 1)

func shipSelectedIndicatorHandler(sidePosition: SideSelectionPosition) -> bool:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	var selectedSide = playerReadyIndicatorParent.get_child(0) if sidePosition == SideSelectionPosition.TOP else playerReadyIndicatorParent.get_child(1)
	tween.tween_property(selectedSide, "visible", true, 0.1)
	tween.tween_property(selectedSide, "modulate", Color("#ffffff1e"), 0.6667).from(Color("#ffffff"))
	return true

func bgTextTextureShineAnim(selectionPos: SideSelectionPosition) -> void:
	var tween: Tween = create_tween()
	var selectedSide = topTextureTextShineGradient if selectionPos == SideSelectionPosition.TOP else bottomTextureTextShineGradient
	if selectionPos == SideSelectionPosition.TOP:
		tween.tween_property(selectedSide, "position", Vector2(0, 265), 0.5).from(Vector2(0, -265))
	else:
		tween.tween_property(selectedSide, "position", Vector2(0, -265), 0.5).from(Vector2(0, 265))

func hideChoiceIndicator(indicator: Control) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(indicator.get_child(0), "modulate", Color("#ffffff00"), 0.1137).from_current()
	tween.tween_property(indicator.get_child(2), "modulate", Color("#ffffff00"), 0.1137).from_current()

func stageTransitionHandler() -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(playerReadyIndicatorParent.get_child(0), "modulate", Color("#ffffff"), 1).from_current()
	tween.tween_property(playerReadyIndicatorParent.get_child(1), "modulate", Color("#ffffff"), 1).from_current()
	GameManager.P1SelectedShip = P1CurrentShipSelection
	GameManager.P2SelectedShip = P2CurrentShipSelection
	SceneTransition.loadScene("res://src/main.tscn")
	await tween.finished
	playerReadyIndicatorParent.get_child(0).visible = false
	playerReadyIndicatorParent.get_child(1).visible = false
