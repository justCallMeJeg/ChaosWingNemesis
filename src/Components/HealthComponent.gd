extends Node2D

class_name HealthComponent

@export var max_health: int = 100
var current_health: int

signal health_changed(new_health: int)
signal died

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount
	emit_signal("health_changed", current_health)
	if current_health <= 0:
		emit_signal("died")
