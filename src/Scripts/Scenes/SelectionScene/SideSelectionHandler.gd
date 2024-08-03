extends Node

@onready var P1Indicator = $"../SideSelectionIndicator/P1Indicator"
@onready var P2Indicator = $"../SideSelectionIndicator/P2Indicator"
@onready var TopSelectedIndicator = $"../SideSelectedIndicator/TopSideSelectedTexture"
@onready var BottomSelectedIndicator = $"../SideSelectedIndicator/BottomSideSelectedTexture"
@onready var leftBorderAnimPlayer = $"../BorderUI/LeftBorderColor/AnimationPlayer"

# Constants for side select indicator positions
const DEFAULT_POSITION = 620
const TOP_POSITION = 265
const BOTTOM_POSITION = 965

# Enums for scene states
enum SelectionStages { SideSelect, ShipSelect, SceneSelect }
enum SideSelectionPosition { DEFAULT = -1, TOP, BOTTOM }

# Vars for various scene states
var CurrentSceneStage: SelectionStages = SelectionStages.SideSelect
var disableP1Input: bool = true
var disableP2Input: bool = true
var P1SidePosition: SideSelectionPosition = SideSelectionPosition.DEFAULT
var P2SidePosition: SideSelectionPosition = SideSelectionPosition.DEFAULT
var isP1Selected: bool = false
var isP2Selected: bool = false

# Signals for outside execution
signal P1SideSelected()
signal P2SideSelected()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("SelectionSceneHandler ready!")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match CurrentSceneStage:
			SelectionStages.SideSelect:
				handleSideSelection(event)

# Handles side selection input based on the current event
func handleSideSelection(event: InputEventKey) -> void:
	match event.keycode:
		KEY_W, KEY_S:
			handlePlayerInput(P1Indicator, P1SidePosition, isP1Selected, "disableP1Input", event, KEY_W, KEY_S)
		KEY_UP, KEY_DOWN:
			handlePlayerInput(P2Indicator, P2SidePosition, isP2Selected, "disableP2Input", event, KEY_UP, KEY_DOWN)
		KEY_SPACE:
			handlePlayerSelection(
				P1SidePosition, isP1Selected, isP2Selected,
				P2SidePosition, "disableP1Input", P1Indicator, handleP1Selected
			)
		KEY_ENTER:
			handlePlayerSelection(
				P2SidePosition, isP2Selected, isP1Selected,
				P1SidePosition, "disableP2Input", P2Indicator, handleP2Selected
			)

# Handles player input for moving the side selection indicator
func handlePlayerInput(
	indicator: Control,
	sidePosition: SideSelectionPosition,
	isSelected: bool,
	inputDisabled: String,
	event: InputEventKey,
	keyUp: int,
	keyDown: int
) -> void:
	if isSelected or get(inputDisabled):
		return
	var newPosition = sideSelectionInputHandler(indicator, sidePosition, event, keyUp, keyDown)
	if indicator == P1Indicator:
		P1SidePosition = newPosition
	else:
		P2SidePosition = newPosition

# Handles side confirmation logic for a player
func handlePlayerSelection(
	sidePosition: SideSelectionPosition,
	isSelected: bool,
	otherPlayerSelected: bool,
	otherSidePosition: SideSelectionPosition,
	inputDisabled: String,
	indicator: Control,
	selectionHandler: Callable
) -> void:
	if sidePosition == SideSelectionPosition.DEFAULT:
		showIndicatorErrorAnimation(indicator, inputDisabled)
		return
	if otherPlayerSelected and sidePosition == otherSidePosition:
		showIndicatorErrorAnimation(indicator, inputDisabled)
		return
	if isSelected or get(inputDisabled):
		return
	selectionHandler.call()

# Updates side selection position and handles tween animation
func sideSelectionInputHandler(indicator: Control, state: SideSelectionPosition, event: InputEventKey, keyUp: int, keyDown: int) -> SideSelectionPosition:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	match event.keycode:
		keyUp:
			match state:
				SideSelectionPosition.DEFAULT:
					state = SideSelectionPosition.TOP
					tween.tween_property(indicator, "position", Vector2(indicator.position.x, TOP_POSITION), 0.1).from(Vector2(indicator.position.x, DEFAULT_POSITION))
				SideSelectionPosition.BOTTOM:
					state = SideSelectionPosition.DEFAULT
					tween.tween_property(indicator, "position", Vector2(indicator.position.x, DEFAULT_POSITION), 0.1).from_current()
				_:
					tween.kill()
		keyDown:
			match state:
				SideSelectionPosition.DEFAULT:
					state = SideSelectionPosition.BOTTOM
					tween.tween_property(indicator, "position", Vector2(indicator.position.x, BOTTOM_POSITION), 0.1).from(Vector2(indicator.position.x, DEFAULT_POSITION))
				SideSelectionPosition.TOP:
					state = SideSelectionPosition.DEFAULT
					tween.tween_property(indicator, "position", Vector2(indicator.position.x, DEFAULT_POSITION), 0.1).from_current()
				_:
					tween.kill()
	return state

# Handles side selection animation
func handleP1Selected() -> void:
	isP1Selected = sideSelectedIndicatorHandler(P1SidePosition)
	leftBorderAnimPlayer.play("active")

func handleP2Selected() -> void:
	isP2Selected = sideSelectedIndicatorHandler(P2SidePosition)

# Generic function to handle side selection animation
func sideSelectedIndicatorHandler(selectionState: SideSelectionPosition) -> bool:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	var selectedSide = TopSelectedIndicator if selectionState == SideSelectionPosition.TOP else BottomSelectedIndicator
	tween.tween_property(selectedSide, "visible", true, 0.1)
	tween.tween_property(selectedSide, "modulate", Color("#ffffff0a"), 0.4667).from_current()
	return true

# Shows error animation for invalid side selection
func showIndicatorErrorAnimation(indicator: Control, input_disabled: String) -> void:
	if get(input_disabled):
		return
	set(input_disabled, true)
	await indicatorErrorAnim(indicator).finished
	set(input_disabled, false)

# Error animation for invalid side selection
func indicatorErrorAnim(indicator: Control) -> Tween:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(indicator, "position", Vector2(indicator.position.x + 25, indicator.position.y), 0.0667)
	tween.tween_property(indicator, "position", Vector2(indicator.position.x - 50, indicator.position.y), 0.0667)
	tween.tween_property(indicator, "position", Vector2(indicator.position.x + 50, indicator.position.y), 0.0667)
	tween.tween_property(indicator, "position", Vector2(indicator.position.x, indicator.position.y), 0.0667)
	return tween

func _on_selection_scene_selection_scene_stage_changed(selectionSceneStage):
	CurrentSceneStage = selectionSceneStage

func _on_selection_scene_animation_intro_finished():
	disableP1Input = false
	disableP2Input = false
