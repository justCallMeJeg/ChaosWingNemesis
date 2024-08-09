extends Control
@onready var animPlayer = $AnimPlayer

func _ready():
	animPlayer.play("idleLoop")
	print("[DEBUG] Game Scene Loop playing...")
