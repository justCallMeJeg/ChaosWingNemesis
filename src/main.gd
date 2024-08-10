extends CanvasLayer

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer

const CONSTRUCTOR = preload("res://src/Scenes/ShipTypes/Constructor.tscn")
const JUGGERNAUT = preload("res://src/Scenes/ShipTypes/Juggernaut.tscn")
const PHANTOM = preload("res://src/Scenes/ShipTypes/Phantom.tscn")
const RAZOR = preload("res://src/Scenes/ShipTypes/Razor.tscn")

const DEFAULT_X_POS: int = 360
const Y_TopPLayer_POS: int = 210
const Y_BottomPLayer_POS: int = 1020

var P1SidePos: int
var P2SidePos: int

var P1Ship
var P2Ship

var availableShips: Array[PackedScene] = [
	preload("res://src/Scenes/ShipTypes/Razor.tscn"),
	preload("res://src/Scenes/ShipTypes/Juggernaut.tscn"),
	preload("res://src/Scenes/ShipTypes/Phantom.tscn"),
	preload("res://src/Scenes/ShipTypes/Constructor.tscn")
]

const TERAN = preload("res://src/Scenes/GameScenes/Teran.tscn")
const HORIZON = preload("res://src/Scenes/GameScenes/Horizon.tscn")
const HORIZON_MUSIC = preload("res://src/Assets/Sound/BG/HORIZON.ogg")
const TERAN_MUSIC = preload("res://src/Assets/Sound/BG/TERAN.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	var instance
	if RandomNumberGenerator.new().randi_range(0, 1) == 0:
		instance = TERAN.instantiate()
		audioPlayer.stream = TERAN_MUSIC
		audioPlayer.play()
	else:
		instance = HORIZON.instantiate()
		audioPlayer.stream = HORIZON_MUSIC
		audioPlayer.play()
	add_child(instance)
	move_child(instance, 1)
	playerSetup()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R: # REMOVE THIS BEFORE RELEASE
			get_tree().reload_current_scene() # REMOVE THIS BEFORE RELEASE
		elif event.keycode == KEY_ESCAPE: # REMOVE THIS BEFORE RELEASE
			SceneTransition.loadScene("res://src/Scenes/MainMenu.tscn")

func _process(delta) -> void:
	if not is_instance_valid(P1Ship):
		print("P1 Dead")
	if not is_instance_valid(P2Ship):
		print("P2 Dead")

func playerSetup() -> void:
	P1Ship = availableShips[GameManager.P1SelectedShip].instantiate()
	P2Ship = availableShips[GameManager.P2SelectedShip].instantiate()
	#P1Ship.get_child(3).set_script("res://src/Scripts/Components/P1InputComponent.gd")
	#P1Ship.get_child(3).set("MOVE_COMPONENT", P1Ship.get_child(2)) 
	P1Ship.set_collision_mask(5)
	P1Ship.get_child(3).set("SPEED", 500) 
	P1Ship.get_child(3).set("player_ID", "1") 
	P1Ship.set_collision_layer(2)
	P1Ship.get_child(5).set("Collision_Mask", 69)#BulletMask
	P1Ship.get_child(5).set("Collision_Layer", 8)#BulletLayer
	P1Ship.get_child(9).set_collision_mask(16)
	P1Ship.get_child(9).set_collision_layer(32)
	
	#P2Ship.get_child(3).set_script("res://src/Scripts/Components/P2InputComponent.gd")
	#P2Ship.get_child(3).set("MOVE_COMPONENT", P2Ship.get_child(2)) 
	P2Ship.set_collision_mask(3)
	P2Ship.get_child(3).set("SPEED", 500)
	P2Ship.get_child(3).set("player_ID", "2")  
	P2Ship.set_collision_layer(4)
	P2Ship.get_child(5).set("Collision_Layer", 16)#BulletLayer
	P2Ship.get_child(5).set("Collision_Mask", 35)#BulletMask
	P2Ship.get_child(9).set_collision_mask(8)
	P2Ship.get_child(9).set_collision_layer(64)
	
	add_child(P1Ship)
	add_child(P2Ship)
	move_child(P1Ship, 3)
	move_child(P2Ship, 4)
	if GameManager.P1SelectedSide == 0:
		P1Ship.position = Vector2(DEFAULT_X_POS, Y_TopPLayer_POS)
		P2Ship.position = Vector2(DEFAULT_X_POS, Y_BottomPLayer_POS)
		P1Ship.rotation = P2Ship.rotation + 1 * PI
	else: 
		P1Ship.position = Vector2(DEFAULT_X_POS, Y_BottomPLayer_POS)
		P2Ship.position = Vector2(DEFAULT_X_POS, Y_TopPLayer_POS)
		P2Ship.rotation = P2Ship.rotation + 1 * PI
