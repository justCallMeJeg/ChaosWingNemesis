# res://Scripts/Player.gd
extends BaseShip

var speed = 200  # Speed of the spaceship
var screen_size = Vector2()  # Size of the game window

func _ready():
	screen_size = get_viewport_rect().size
	configure_collision()

func configure_collision():
	var shape = RectangleShape2D.new()
	collision_component.set_shape(shape)
	collision_component.set_shape_extents(Vector2(32, 32))  # Example extents

func _process(delta):
	var velocity = Vector2()  # Movement vector

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta

	# Keep the player within screen bounds
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
