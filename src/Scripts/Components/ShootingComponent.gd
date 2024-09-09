class_name ShootingComponent
extends Node
@onready var BULLET_SCENE : String 
@onready var main = get_tree().get_root().get_node("Main")
@onready var PROJECTILE = load("res://src/Scenes/BulletTypes/"+BULLET_SCENE+".tscn")

@export var ACTOR : Node2D
@export var TIMER : Timer
var BULLET_SIZE : float = 0.0 #You can change this value to change bullet size
var Collision_Mask : int = 0
var Collision_Layer : int = 0
var BulletClass : String
var instance = {}
var bulletvariation = [0, -0.1, 0.1]

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2).timeout
	TIMER.start()
	TIMER.set_autostart(true)
	
	#shoot()
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():#gonna do a switch case
	if BulletClass == "BulletSpread":
		bulletSpread()
	elif BulletClass == "TripleBullet":
		tripleBullet()
	elif BulletClass == "BulletBarrage":
		bulletBarrage()
	elif BulletClass == "SniperBullet":
		sniperBullet()
	else:
		normalBullet()
		
	

func normalBullet():
	instance = PROJECTILE.instantiate()
	instance.dir = ACTOR.rotation
	instance.instantiatePosition = ACTOR.global_position
	instance.instantiateRotation = ACTOR.rotation
	instance.get_node("BulletBody").scale += Vector2(BULLET_SIZE,BULLET_SIZE)#This line changes bullet size
	instance.get_node("CollisionShape2D").scale += Vector2(BULLET_SIZE,BULLET_SIZE)
	instance.get_child(2).set_collision_layer(Collision_Layer)
	instance.get_child(2).set_collision_mask(Collision_Mask)
	instance.zIndex = ACTOR.z_index - 1
	main.add_child(instance)

func bulletSpread():
	for i in range(0,3):
		instance[i] = PROJECTILE.instantiate()
		instance[i].dir = ACTOR.rotation + bulletvariation[i] * PI
		instance[i].instantiatePosition = ACTOR.global_position
		instance[i].instantiateRotation = ACTOR.rotation + bulletvariation[i] * PI
		instance[i].BulletSpeed -= 400
		instance[i].get_node("BulletBody").scale -= Vector2(BULLET_SIZE*0.25,BULLET_SIZE*0.25)#This line changes bullet size
		instance[i].get_node("CollisionShape2D").scale -= Vector2(BULLET_SIZE*0.25,BULLET_SIZE*0.25)
		instance[i].get_child(2).set_collision_layer(Collision_Layer)
		instance[i].get_child(2).set_collision_mask(Collision_Mask)
		instance[i].zIndex = ACTOR.z_index - 1
		main.add_child(instance[i])

func tripleBullet():
	bulletvariation = [0, -50, 50]
	for i in range(0,3):
		instance[i] = PROJECTILE.instantiate()
		instance[i].dir = ACTOR.rotation 
		instance[i].instantiatePosition = ACTOR.global_position + Vector2(bulletvariation[i],0)
		instance[i].instantiateRotation = ACTOR.rotation 
		instance[i].BulletSpeed -= 300
		instance[i].BulletDamage -= 2.5
		instance[i].get_node("BulletBody").scale -= Vector2(BULLET_SIZE*0.25,BULLET_SIZE*0.25)#This line changes bullet size
		instance[i].get_node("CollisionShape2D").scale -= Vector2(BULLET_SIZE*0.25,BULLET_SIZE*0.25)
		instance[i].get_child(2).set_collision_layer(Collision_Layer)
		instance[i].get_child(2).set_collision_mask(Collision_Mask)
		instance[i].zIndex = ACTOR.z_index - 1
		main.add_child(instance[i])

func bulletBarrage():
	bulletvariation = [0, 75, -75]
	for i in range(0,3):
		instance[i] = PROJECTILE.instantiate()
		instance[i].dir = ACTOR.rotation 
		instance[i].instantiatePosition = ACTOR.global_position + Vector2(0,bulletvariation[i])
		instance[i].instantiateRotation = ACTOR.rotation 
		instance[i].BulletSpeed -= 400
		instance[i].BulletDamage -= 5.5
		instance[i].get_node("BulletBody").scale -= Vector2(BULLET_SIZE*0.25,BULLET_SIZE*0.25)#This line changes bullet size
		instance[i].get_node("CollisionShape2D").scale -= Vector2(BULLET_SIZE*0.25,BULLET_SIZE*0.25)
		instance[i].get_child(2).set_collision_layer(Collision_Layer)
		instance[i].get_child(2).set_collision_mask(Collision_Mask)
		instance[i].zIndex = get_parent().z_index - 1
		main.add_child(instance[i])

func sniperBullet():
	instance = PROJECTILE.instantiate()
	instance.dir = ACTOR.rotation
	instance.instantiatePosition = ACTOR.global_position
	instance.instantiateRotation = ACTOR.rotation
	instance.BulletSpeed += 500
	instance.BulletDamage += 20.0
	instance.get_node("BulletBody").scale += Vector2(BULLET_SIZE+0.125,BULLET_SIZE+0.125)#This line changes bullet size
	instance.get_node("CollisionShape2D").scale += Vector2(BULLET_SIZE+0.125,BULLET_SIZE+0.125)
	instance.get_child(2).set_collision_layer(Collision_Layer)
	instance.get_child(2).set_collision_mask(Collision_Mask)
	instance.zIndex = ACTOR.z_index - 1
	main.add_child(instance)

func _on_bullet_interval_timeout():
	shoot()
