class_name ShootingComponent
extends Node
@export var BULLET_SCENE : String
@onready var main = get_tree().get_root().get_node("Main")
@onready var PROJECTILE = load("res://src/Scenes/BulletTypes/"+BULLET_SCENE+".tscn")

@export var ACTOR : Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	shoot()
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	var instance = PROJECTILE.instantiate()
	instance.dir = ACTOR.rotation
	instance.instantiatePosition = ACTOR.global_position
	instance.instantiateRotation = ACTOR.rotation
	instance.zIndex = ACTOR.z_index - 1
	main.add_child.call_deferred(instance)
	


func _on_bullet_interval_timeout():
	shoot()
