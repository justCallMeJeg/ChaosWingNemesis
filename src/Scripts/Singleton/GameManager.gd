extends Node

enum selectionStages { SideSelect, ShipSelect, SceneSelect }
enum playerSides { DEFAULT = -1, TOP, BOTTOM }
enum availableShips { RAZOR, JUGGERNAUT, PHANTOM, CONSTRUCTOR }
enum availableScenes { HORIZON, TERAN }

var currentSelectionStage: selectionStages = selectionStages.SideSelect
var P1SelectedSide: int = playerSides.DEFAULT
var P2SelectedSide: int = playerSides.DEFAULT
var P1SelectedShip: int = availableShips.RAZOR
var P2SelectedShip: int = availableShips.RAZOR
var selectedScene: int = availableScenes.HORIZON

var roundStart: bool = false

var P1Wins: int = 0
var P2Wins: int = 0
