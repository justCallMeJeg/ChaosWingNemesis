extends Node

@onready var P1Indicator = $"../SideSelectionIndicator/P1Indicator"
@onready var P2Indicator = $"../SideSelectionIndicator/P2Indicator"

@onready var TopSelectedIndicator = $"../PlayerReadyIndicator/TopSideSelectedTexture"
@onready var BottomSelectedIndicator = $"../PlayerReadyIndicator/BottomSideSelectedTexture"

@onready var topTextureText = $"../BGTextTexture/TopTextureTextContainer/TopTextureText"
@onready var bottomTextureText = $"../BGTextTexture/BottomTextureTextContainer/BottomTextureText"

@onready var upperSubtitle = $"../MainText/UpperSubtitle"
@onready var lowerSubtitle = $"../MainText/LowerSubtitle"

@onready var topTextureTextShineGradient = $"../BGTextTexture/TopTextureTextContainer/TopTextureText/TopTextureTextShineGradient"
@onready var bottomTextureTextShineGradient = $"../BGTextTexture/BottomTextureTextContainer/BottomTextureText/BottomTextureTextShineGradient"

@onready var leftBorderText = $"../BorderUI/LeftBorderColor/LeftBorderTexture/LeftBorderContainer/LeftMarginContainer/LeftBorderText"
@onready var rightBorderText = $"../BorderUI/RightBorderColor/RightBorderTexture/RightBorderContainer/RightMarginContainer/RightBorderText"

@onready var topTooltipText = $"../TooltipUI/TopTooltipContainer/MarginContainer/TopTooltipText"
@onready var bottomTooltipText = $"../TooltipUI/BottomTooltipContainer/MarginContainer/BottomTooltipText"

@onready var leftBorderAnimPlayer = $"../BorderUI/LeftBorderColor/BorderAnimPlayer"
@onready var rightBorderAnimPlayer = $"../BorderUI/RightBorderColor/BorderAnimPlayer"
@onready var indicatorAnimPlayer = $"../SideSelectionIndicator/IndicatorAnimPlayer"

@onready var sfxPlayer: AudioStreamPlayer = $"../SFXPlayer"


# Constants for assets
const ERROR_SFX = preload("res://src/Assets/Sound/UI/ErrorSFX.wav")
const CONFIRM_SFX = preload("res://src/Assets/Sound/UI/ConfirmSFX.wav")

# Constants for side select indicator positions
const DEFAULT_POSITION = 620
const TOP_POSITION = 265
const BOTTOM_POSITION = 965

# Enums for scene states
enum SelectionStages { SideSelect, ShipSelect, SceneSelect }
enum SideSelectionPosition { DEFAULT = -1, TOP, BOTTOM }

# Vars for various scene states
var disableP1Input: bool = true
var disableP2Input: bool = true
var P1SidePosition: SideSelectionPosition = SideSelectionPosition.DEFAULT
var P2SidePosition: SideSelectionPosition = SideSelectionPosition.DEFAULT
var isP1Selected: bool = false
var isP2Selected: bool = false

# Signals for outside execution
signal SideSelectFinished(P1SidePosition, P2SidePosition)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("SelectionSceneHandler ready!")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if get_parent().CurrentSceneStage == SelectionStages.SideSelect:
			handleSideSelection(event)
			if isP1Selected and isP2Selected:
				stageTransitionHandler()

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
	if sidePosition == SideSelectionPosition.DEFAULT or (otherPlayerSelected and sidePosition == otherSidePosition) or isSelected or get(inputDisabled):
		showIndicatorErrorAnimation(indicator, inputDisabled, sidePosition)
	else:
		selectionHandler.call(sidePosition)

# Updates side selection position and handles tween animation
func sideSelectionInputHandler(indicator: Control, state: SideSelectionPosition, event: InputEventKey, keyUp: int, keyDown: int) -> SideSelectionPosition:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
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
func handleP1Selected(selectionState: SideSelectionPosition) -> void:
	isP1Selected = sideSelectedIndicatorHandler(P1SidePosition)
	disableP1Input = true
	leftBorderText.text = "PLAYER 1 READY!"
	updateTooltipAndPlaySound(selectionState, topTooltipText, bottomTooltipText, "Waiting for Player 2...")
	setBGTextTexture(P1Indicator, selectionState)
	leftBorderAnimPlayer.play("PlayerReadyState")

func handleP2Selected(selectionState: SideSelectionPosition) -> void:
	isP2Selected = sideSelectedIndicatorHandler(P2SidePosition)
	disableP2Input = true
	rightBorderText.text = "PLAYER 2 READY!"
	updateTooltipAndPlaySound(selectionState, topTooltipText, bottomTooltipText, "Waiting for Player 1...")
	setBGTextTexture(P2Indicator, selectionState)
	rightBorderAnimPlayer.play("PlayerReadyState")

# Updates tooltip text and plays the selection sound effect
func updateTooltipAndPlaySound(selectionState: SideSelectionPosition, topTooltip: Label, bottomTooltip: Label, waitingText: String) -> void:
	var selectedSide = topTooltip if selectionState == SideSelectionPosition.TOP else bottomTooltip
	selectedSide.text = waitingText
	playSound(CONFIRM_SFX, 1.0, 1.5)

# Plays a sound with a random pitch scale
func playSound(sound: AudioStream, min_pitch: float, max_pitch: float) -> void:
	sfxPlayer.stream = sound
	sfxPlayer.pitch_scale = RandomNumberGenerator.new().randf_range(min_pitch, max_pitch)
	sfxPlayer.play()

# Generic function to handle side selection animation
func sideSelectedIndicatorHandler(selectionState: SideSelectionPosition) -> bool:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	var selectedSide = TopSelectedIndicator if selectionState == SideSelectionPosition.TOP else BottomSelectedIndicator
	tween.tween_property(selectedSide, "visible", true, 0.1)

	tween.tween_property(selectedSide, "modulate", Color("#ffffff1e"), 0.6667).from(Color("#ffffff"))
	return true

# Shows error animation for invalid side selection
func showIndicatorErrorAnimation(indicator: Control, input_disabled: String, state: SideSelectionPosition) -> void:
	if get(input_disabled):
		return
	set(input_disabled, true)
	await indicatorErrorAnim(indicator, state).finished
	set(input_disabled, false)

# Error animation for invalid side selection
func indicatorErrorAnim(indicator: Control, selectionState: SideSelectionPosition) -> Tween:
	playSound(ERROR_SFX, 0.75, 1.0)
	var indicatorTween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	indicatorTween.tween_property(indicator, "position", Vector2(indicator.position.x + 25, indicator.position.y), 0.0667)
	indicatorTween.tween_property(indicator, "position", Vector2(indicator.position.x - 50, indicator.position.y), 0.0667)
	indicatorTween.tween_property(indicator, "position", Vector2(indicator.position.x + 50, indicator.position.y), 0.0667)
	indicatorTween.tween_property(indicator, "position", Vector2(indicator.position.x, indicator.position.y), 0.0667)

	if selectionState != SideSelectionPosition.DEFAULT:
		var textTween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		var textSide = upperSubtitle if selectionState == SideSelectionPosition.TOP else lowerSubtitle
		textSide.text = "SIDE ALREADY TAKEN"
		textTween.tween_property(textSide, "visible", true, 0)
		textTween.tween_property(textSide, "modulate", Color("#ffffff00"), 1).from(Color("#ff0000"))
	
	return indicatorTween

func setBGTextTexture(indicator: Control, selectionState: SideSelectionPosition) -> void:
	var tween: Tween = create_tween()
	var selectedSide = topTextureTextShineGradient if selectionState == SideSelectionPosition.TOP else bottomTextureTextShineGradient
	if selectionState == SideSelectionPosition.TOP:
		tween.tween_property(selectedSide, "position", Vector2(0, 265), 0.5).from(Vector2(0, -265))
	else:
		tween.tween_property(selectedSide, "position", Vector2(0, -265), 0.5).from(Vector2(0, 265))
	
	selectedSide = topTextureText if selectionState == SideSelectionPosition.TOP else bottomTextureText
	if indicator == P1Indicator:
		selectedSide.text = "PLAYER 1\nPLAYER 1\nPLAYER 1\nPLAYER 1"
	else:
		selectedSide.text = "PLAYER 2\nPLAYER 2\nPLAYER 2\nPLAYER 2"

func stageTransitionHandler() -> void:
	indicatorAnimPlayer.play("StageTransitionState")
	await indicatorAnimPlayer.animation_finished
	TopSelectedIndicator.visible = false
	BottomSelectedIndicator.visible = false
	get_parent().CurrentSceneStage = SelectionStages.ShipSelect
	GameManager.P1SelectedSide = P1SidePosition
	GameManager.P2SelectedSide = P2SidePosition
	SideSelectFinished.emit(P1SidePosition, P2SidePosition)

func _on_selection_scene_animation_intro_finished():
	disableP1Input = false
	disableP2Input = false
