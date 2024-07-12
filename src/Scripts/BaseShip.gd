extends Node2D

class_name BaseShip

var health_component: HealthComponent = null
var weapon_component: WeaponComponent = null
var movement_component: MovementComponent = null
var collision_component: CollisionComponent = null

func _ready():
	health_component = $HealthComponent
	weapon_component = $WeaponComponent
	movement_component = $MovementComponent
	collision_component = $CollisionComponent

func _process(delta):
	movement_component.update(delta)
	if Input.is_action_just_pressed("fire"):
		weapon_component.fire_weapon()
