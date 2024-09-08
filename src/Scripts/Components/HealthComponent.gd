class_name HealthComponent
extends Node

@onready var HITBOX_COMPONENT: Area2D = $"/root/Main/BaseShip/HitboxComponent"
@export var HP_BAR: Control
@export var MAX_HEALTH : int = 3
@export var HEALTH: int
@onready var CollisionPolygon : CollisionPolygon2D = $"/root/Main/BaseShip/HitboxComponent/CollisionPolygon2D"

# Node Signals for external functions/components
signal healthDepleted()
signal healthChanged()

func _ready():
	HEALTH = MAX_HEALTH
	HP_BAR.get_child(0).max_value = MAX_HEALTH
	HP_BAR.get_child(0).value = HEALTH


func HP_Refresh():
	HP_BAR.get_child(0).value = HEALTH
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var hurt = HITBOX_COMPONENT.get_overlapping_bodies()
	#if hurt.size() > 0:
		#HEALTH -= 1 * hurt.size() * delta 
		#HP_BAR.get_node("ProgressBar").value = HEALTH
		#print(HEALTH)
		#CollisionPolygon.set_deferred("disabled",true)
		#await get_tree().create_timer(1).timeout #I-frames in seconds
		#CollisionPolygon.set_deferred("disabled",false)
	
	#if HEALTH <= 0:
		#healthDepleted.emit()
		#get_parent().queue_free()#dead
	pass





func _on_hitbox_component_body_entered(hitbox):
	print(HEALTH)
	
