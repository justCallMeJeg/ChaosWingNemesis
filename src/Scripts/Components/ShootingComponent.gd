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
		
		var instance = PROJECTILE.instantiate()
		var instance2 = PROJECTILE.instantiate()
		var instance3 = PROJECTILE.instantiate()
		
		instance.dir = ACTOR.rotation
		instance.instantiatePosition = ACTOR.global_position
		instance.instantiateRotation = ACTOR.rotation
		instance.get_node("BulletBody").scale += Vector2(BULLET_SIZE,BULLET_SIZE)#This line changes bullet size
		instance.get_node("CollisionShape2D").scale += Vector2(BULLET_SIZE,BULLET_SIZE)
		instance.get_child(2).set_collision_layer(Collision_Layer)
		instance.get_child(2).set_collision_mask(Collision_Mask)
		instance.zIndex = ACTOR.z_index - 1
		main.add_child(instance)
		
		instance2.dir = ACTOR.rotation + 0.1*PI
		instance2.instantiatePosition = ACTOR.global_position
		instance2.instantiateRotation = ACTOR.rotation + 0.1 * PI
		instance2.get_node("BulletBody").scale += Vector2(BULLET_SIZE,BULLET_SIZE)#This line changes bullet size
		instance2.get_node("CollisionShape2D").scale += Vector2(BULLET_SIZE,BULLET_SIZE)
		instance2.get_child(2).set_collision_layer(Collision_Layer)
		instance2.get_child(2).set_collision_mask(Collision_Mask)
		instance2.zIndex = ACTOR.z_index - 1
		main.add_child(instance2)
		
		instance3.dir = ACTOR.rotation - 0.1*PI
		instance3.instantiatePosition = ACTOR.global_position
		instance3.instantiateRotation = ACTOR.rotation - 0.1*PI
		instance3.get_node("BulletBody").scale += Vector2(BULLET_SIZE,BULLET_SIZE)#This line changes bullet size
		instance3.get_node("CollisionShape2D").scale += Vector2(BULLET_SIZE,BULLET_SIZE)
		instance3.get_child(2).set_collision_layer(Collision_Layer)
		instance3.get_child(2).set_collision_mask(Collision_Mask)
		instance3.zIndex = ACTOR.z_index - 1
		main.add_child(instance3)
		
	
	


func _on_bullet_interval_timeout():
	shoot()
