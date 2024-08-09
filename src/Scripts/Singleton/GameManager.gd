extends Node

enum selectionStages { SideSelect, ShipSelect, SceneSelect }
enum playerSides { DEFAULT = -1, TOP, BOTTOM }
enum availableShips { RAZOR, JUGGERNAUT, PHANTOM, CONSTRUCTOR }
enum availableScenes { HORIZON, TERAN }

var currentSelectionStage: selectionStages = selectionStages.SideSelect
var P1SelectedSide: playerSides = playerSides.DEFAULT
var P2SelectedSide: playerSides = playerSides.DEFAULT
var P1SelectedShip: availableShips = availableShips.RAZOR
var P2SelectedShip: availableShips = availableShips.RAZOR
var selectedScene: availableScenes = availableScenes.HORIZON
