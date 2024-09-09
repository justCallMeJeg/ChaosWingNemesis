extends CanvasLayer

@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var label = $Label

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

var gameEnd: bool = false

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

#Augments
var SMOL = preload("res://src/Scenes/Augments/SMOL.tscn").instantiate()
var FUELED = preload("res://src/Scenes/Augments/FUELED.tscn").instantiate()
var GIGGA =  preload("res://src/Scenes/Augments/GIGGA.tscn").instantiate()
var RAPIDFIRE = preload("res://src/Scenes/Augments/RAPIDFIRE.tscn").instantiate()
var TRIPLESHOT = preload("res://src/Scenes/Augments/TripleShot.tscn").instantiate()

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
	if not gameEnd:
		if not is_instance_valid(P1Ship):
			gameEnd = true
			p2win()
		if not is_instance_valid(P2Ship):
			gameEnd = true
			p1win()

func playerSetup() -> void:
	P1Ship = availableShips[GameManager.P1SelectedShip].instantiate()
	P2Ship = availableShips[GameManager.P2SelectedShip].instantiate()
	#P1Ship.get_child(3).set_script("res://src/Scripts/Components/P1InputComponent.gd")
	#P1Ship.get_child(3).set("MOVE_COMPONENT", P1Ship.get_child(2)) 
	#P1Ship.name = "Player1"
	P1Ship.set_collision_mask(5)
	P1Ship.set("SPEED", 400) 
	P1Ship.set("player_ID", "1")
	P1Ship.set_collision_layer(2)
	P1Ship.get_child(5).set("Collision_Mask", 69)#BulletMask
	P1Ship.get_child(5).set("Collision_Layer", 8)#BulletLayer
	P1Ship.get_child(9).set_collision_mask(16)
	P1Ship.get_child(9).set_collision_layer(32)
	#adding augments
	#P1Ship.get_child(6).add_child(TRIPLESHOT.duplicate())
	#adding different bullets
	match P1Ship.ShipType:
		"Constructor":
			P1Ship.get_child(5).set("BulletClass", "BulletSpread")
			P1Ship.get_child(7).set("wait_time", 0.5)
			P1Ship.get_child(5).set("BULLET_SCENE", "Bullet")
		"Juggernaut":
			P1Ship.get_child(5).set("BulletClass", "BulletBarrage")
			P1Ship.get_child(7).set("wait_time", 1)
			P1Ship.get_child(5).set("BULLET_SCENE", "Bullet")
		"Hawkeye":
			print("Do nothing")
			P1Ship.get_child(7).set("wait_time", 0.5)
			P1Ship.get_child(5).set("BULLET_SCENE", "Bullet")
		"Phantom":
			P1Ship.get_child(5).set("BulletClass", "SniperBullet")
			P1Ship.get_child(7).set("wait_time", 1.5)
			P1Ship.get_child(5).set("BULLET_SCENE", "LaserBullet")
		"Razor":
			P1Ship.get_child(5).set("BulletClass", "TripleBullet")
			P1Ship.get_child(7).set("wait_time", 0.5)
			P1Ship.get_child(5).set("BULLET_SCENE", "LaserBullet")
		
		
	#P2Ship.get_child(3).set_script("res://src/Scripts/Components/P2InputComponent.gd")
	#P2Ship.get_child(3).set("MOVE_COMPONENT", P2Ship.get_child(2)) 
	#P2Ship.name = "Player2"
	P2Ship.set_collision_mask(3)
	P2Ship.set("SPEED", 400)
	P2Ship.set("player_ID", "2")  
	P2Ship.set_collision_layer(4)
	P2Ship.get_child(5).set("Collision_Layer", 16)#BulletLayer
	P2Ship.get_child(5).set("Collision_Mask", 35)#BulletMask
	P2Ship.get_child(9).set_collision_mask(8)
	P2Ship.get_child(9).set_collision_layer(64)
	#adding augments
	#P2Ship.get_child(6).add_child(TRIPLESHOT.duplicate())
	#adding different bullets
	match P2Ship.ShipType:
		"Constructor":
			P2Ship.get_child(5).set("BulletClass", "BulletSpread")
			P2Ship.get_child(7).set("wait_time", 0.5)
			P2Ship.get_child(5).set("BULLET_SCENE", "Bullet")
		"Juggernaut":
			P2Ship.get_child(5).set("BulletClass", "BulletBarrage")
			P2Ship.get_child(7).set("wait_time", 1)
			P2Ship.get_child(5).set("BULLET_SCENE", "Bullet")
		"Hawkeye":
			print("Do nothing")
			P2Ship.get_child(7).set("wait_time", 0.5)
			P2Ship.get_child(5).set("BULLET_SCENE", "Bullet")
		"Phantom":
			P2Ship.get_child(5).set("BulletClass", "SniperBullet")
			P2Ship.get_child(7).set("wait_time", 1.5)
			P2Ship.get_child(5).set("BULLET_SCENE", "LaserBullet")
		"Razor":
			P2Ship.get_child(5).set("BulletClass", "TripleBullet")
			P2Ship.get_child(7).set("wait_time", 0.5)
			P2Ship.get_child(5).set("BULLET_SCENE", "LaserBullet")

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

func p1win() -> void:
	label.text = "Player 1 WINS!"
	label.visible = true
	await get_tree().create_timer(3).timeout
	SceneTransition.loadScene("res://src/Scenes/GameEnd.tscn")

func p2win() -> void:
	label.text = "Player 2 WINS!"
	label.visible = true
	await get_tree().create_timer(3).timeout
	SceneTransition.loadScene("res://src/Scenes/GameEnd.tscn")
