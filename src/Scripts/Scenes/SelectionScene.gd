extends Control

@onready var animationPlayer: AnimationPlayer = $UIAnimationPlayer
@onready var P1Indicator = $SideSelectionIndicator/P1Indicator
@onready var P2Indicator = $SideSelectionIndicator/P2Indicator
@onready var TopSelectedIndicator = $SideSelectedIndicator/TopSideSelectedTexture
@onready var BottomSelectedIndicator = $SideSelectedIndicator/BottomSideSelectedTexture

# Constants for side select indicator positions
const DEFAULT_POSITION = 620
const TOP_POSITION = 265
const BOTTOM_POSITION = 965

# Enums for scene states
enum SelectionStages { SideSelect, ShipSelect, SceneSelect }
enum SideSelectionState { DEFAULT, TOP, BOTTOM }

# Vars for various scene states
var CurrentSceneStage: SelectionStages = SelectionStages.SideSelect
var P1SideSelectionInput: bool = true
var P2SideSelectionInput: bool = true
var P1SideSelectionState: SideSelectionState = SideSelectionState.DEFAULT
var P2SideSelectionState: SideSelectionState = SideSelectionState.DEFAULT
var P1SideSelected: bool = false
var P2SideSelected: bool = false

func _ready() -> void:
	animationPlayer.play("SelectionStartIntro") # Plays SelectionStartIntro after scene ready
	animationPlayer.queue("SideSelectionIntro") # Queue SideSelectionIntro after SelectionStartIntro

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R: # REMOVE THIS BEFORE RELEASE
			get_tree().reload_current_scene() # REMOVE THIS BEFORE RELEASE
			
		if CurrentSceneStage == SelectionStages.SideSelect: # Runs handleSideSelectionInput during side select stage
			match event.keycode:
				KEY_W, KEY_S: # Player 1 move and up keys
					if P1SideSelected || !P1SideSelectionInput: return # Ignores input when player already selected
					P1SideSelectionState = handleSideSelectionIndicatorInput(P1Indicator, P1SideSelectionState, event, KEY_W, KEY_S)
				KEY_UP, KEY_DOWN: # Player 2 move and up keys
					if P2SideSelected || !P2SideSelectionInput: return # Ignores input when player already selected
					P2SideSelectionState = handleSideSelectionIndicatorInput(P2Indicator, P2SideSelectionState, event, KEY_UP, KEY_DOWN)
				KEY_SPACE: # Player 1 enter key
					P1SideSelectionInput = false
					await errorSideSelectionAnim(P1Indicator)
					P1SideSelectionInput = true
					#if P1SideSelected || !P1SideSelectionInput: return # Ignores input when player already selected
					#handleP1SideSelected()
				KEY_ENTER: # Player 2 enter key
					if P2SideSelected || !P2SideSelectionInput: return # Ignores input when player already selected
					handleP2SideSelected()

func _process(delta: float) -> void:
	pass

func _on_ui_animation_player_animation_finished(animName: StringName):
	if animName == "SideSelectionIntro":
		P1SideSelectionInput = true
		P2SideSelectionInput = true

func handleSideSelectionIndicatorInput(indicator: Control, state: SideSelectionState, event: InputEventKey, keyUp: Key, keyDown: Key) -> SideSelectionState:
	# Create a tween for smooth movement
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	
	# Handle upward movement
	if event.keycode == keyUp:
		match state:
			SideSelectionState.DEFAULT:
				state = SideSelectionState.TOP
				tween.tween_property(indicator, "position", Vector2(indicator.position.x, TOP_POSITION), 0.1).from(Vector2(indicator.position.x, DEFAULT_POSITION))
			SideSelectionState.BOTTOM:
				state = SideSelectionState.DEFAULT
				tween.tween_property(indicator, "position", Vector2(indicator.position.x, DEFAULT_POSITION), 0.1).from_current()
			_: # Default
				tween.kill()
	# Handle downward movement
	elif event.keycode == keyDown:
		match state:
			SideSelectionState.DEFAULT:
				state = SideSelectionState.BOTTOM
				tween.tween_property(indicator, "position", Vector2(indicator.position.x, BOTTOM_POSITION), 0.1).from(Vector2(indicator.position.x, DEFAULT_POSITION))
			SideSelectionState.TOP:
				state = SideSelectionState.DEFAULT
				tween.tween_property(indicator, "position", Vector2(indicator.position.x, DEFAULT_POSITION), 0.1).from_current()
			_: # Default
				tween.kill()
	return state

func handleP1SideSelected() -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	var selectedSide = TopSelectedIndicator if P1SideSelectionState == SideSelectionState.TOP else BottomSelectedIndicator
	P1SideSelected = true
	tween.tween_property(selectedSide, "visible", true, 0.1)
	tween.tween_property(selectedSide, "modulate", Color("#ffffff0a"), 0.4667).from_current()
	pass

func handleP2SideSelected() -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	var selectedSide = TopSelectedIndicator if P2SideSelectionState == SideSelectionState.TOP else BottomSelectedIndicator
	P2SideSelected = true
	tween.tween_property(selectedSide, "visible", true, 0.1)
	tween.tween_property(selectedSide, "modulate", Color("#ffffff0a"), 0.4667).from_current()
	pass

func errorSideSelectionAnim(indicator: Control) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(indicator, "position", Vector2(250, indicator.position.y), 0.0667)
	tween.tween_property(indicator, "position", Vector2(200, indicator.position.y), 0.0667)
	tween.tween_property(indicator, "position", Vector2(250, indicator.position.y), 0.0667)
	tween.tween_property(indicator, "position", Vector2(225, indicator.position.y), 0.0667)
	pass


