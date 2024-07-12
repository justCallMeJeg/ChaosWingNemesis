extends Node2D

class_name WeaponComponent

@export var cooldown: float = 0.5
var last_shot_time: float = 0.0

func fire_weapon() -> void:
	if Time.get_ticks_msec() / 1000.0 - last_shot_time > cooldown:
		print("Fire weapon")
		last_shot_time = Time.get_ticks_msec() / 1000.0
