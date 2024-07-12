extends Area2D

class_name CollisionComponent

var collision_shape: CollisionShape2D  = null

func _ready():
	collision_shape = CollisionShape2D.new()
	add_child(collision_shape)

func set_shape(shape):
	collision_shape.shape = shape

func set_shape_extents(extents: Vector2):
	if collision_shape.shape is RectangleShape2D:
		collision_shape.shape.extents = extents
	elif collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = extents.x
