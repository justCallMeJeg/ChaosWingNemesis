class_name ShootingComponent
extends Node
@export var BULLET_SCENE : String
@onready var main = get_tree().get_root().get_node("Main")
@onready var PROJECTILE = load("res://src/Scenes/BulletTypes/"+BULLET_SCENE+".tscn")

@export var ACTOR : Node2D
var BULLET_SIZE : float = 0.0 #You can change this value to change bullet size
var Collision_Mask : int = 0
var Collision_Layer : int = 0
var BulletSpread : bool = false
var instance = {}
var bulletvariation = [0, -0.1, 0.1]
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(5).timeout 
	shoot()
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	if BulletSpread == false:
		var instance = PROJECTILE.instantiate()
		instance.dir = ACTOR.rotation
		instance.instantiatePosition = ACTOR.global_position
		instance.instantiateRotation = ACTOR.rotation
		instance.get_node("BulletBody").scale += Vector2(BULLET_SIZE,BULLET_SIZE)#This line changes bullet size
		instance.get_node("CollisionShape2D").scale += Vector2(BULLET_SIZE,BULLET_SIZE)
		instance.get_child(2).set_collision_layer(Collision_Layer)
		instance.get_child(2).set_collision_mask(Collision_Mask)
		instance.zIndex = ACTOR.z_index - 1
		main.add_child(instance)
	else:
		for i in range(0,3):
			instance[i] = PROJECTILE.instantiate()
			instance[i].dir = ACTOR.rotation + bulletvariation[i] * PI
			instance[i].instantiatePosition = ACTOR.global_position
			instance[i].instantiateRotation = ACTOR.rotation + bulletvariation[i] * PI
			instance[i].get_node("BulletBody").scale += Vector2(BULLET_SIZE,BULLET_SIZE)#This line changes bullet size
			instance[i].get_node("CollisionShape2D").scale += Vector2(BULLET_SIZE,BULLET_SIZE)
			instance[i].get_child(2).set_collision_layer(Collision_Layer)
			instance[i].get_child(2).set_collision_mask(Collision_Mask)
			instance[i].zIndex = ACTOR.z_index - 1
			main.add_child(instance[i])
	
	


func _on_bullet_interval_timeout():
	shoot()
