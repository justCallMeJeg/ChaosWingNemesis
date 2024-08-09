extends Node

@export var HITBOX_COMPONENT: Area2D
@export var HEALTH: int = 3
@export var CollisionPolygon : CollisionPolygon2D

# Node Signals for external functions/components
signal healthDepleted()
signal healthChanged()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var hurt = HITBOX_COMPONENT.get_overlapping_bodies()
	if hurt.size() > 0:
		HEALTH -= 1 * hurt.size() * delta 
		print(HEALTH)
		CollisionPolygon.set_deferred("disabled",true)
		await get_tree().create_timer(3).timeout
		CollisionPolygon.set_deferred("disabled",false)
	
	if HEALTH <= 0:
		healthDepleted.emit()
		get_parent().queue_free()



