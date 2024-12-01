extends Camera3D

@export var move_speed: float = 2.0
@export var rotation_speed: float = 0.1
@export var zoom_speed: float = 2.0
@export var min_height: float = 5.0
@export var max_height: float = 20.0

var camera_position: Vector3
var camera_rotation: Vector3

func _ready():
	position = Vector3(0, 10, 10)
	rotation_degrees = Vector3(-45, 0, 0)
	camera_position = position
	camera_rotation = rotation_degrees

func _process(delta):
	position = position.lerp(camera_position, delta * 8)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	handle_input(delta)

func handle_input(delta):
	var input := Vector3.ZERO
	
	if Input.is_action_pressed("camera_left"):
		input.x -= 1
	if Input.is_action_pressed("camera_right"):
		input.x += 1
	if Input.is_action_pressed("camera_forward"):
		input.z -= 1
	if Input.is_action_pressed("camera_back"):
		input.z += 1
	
	input = input.rotated(Vector3.UP, rotation.y).normalized()
	
	if input.length() > 0:
		camera_position += input * move_speed * delta * 60
	
	# Handle zoom
	if Input.is_action_pressed("camera_zoom_in"):
		print("zoooomin")
		camera_position.y = clamp(camera_position.y - zoom_speed * delta, min_height, max_height)
	if Input.is_action_pressed("camera_zoom_out"):
		camera_position.y = clamp(camera_position.y + zoom_speed * delta, min_height, max_height)

	if Input.is_action_pressed("camera_center"):
		camera_position = Vector3(0, 10, 10)
		camera_rotation = Vector3(-45, 0, 0)

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("camera_rotate"):
			camera_rotation += Vector3(0, -event.relative.x * rotation_speed, 0)
			# Add vertical rotation with limits
			var new_x_rotation = camera_rotation.x - event.relative.y * rotation_speed
			camera_rotation.x = clamp(new_x_rotation, -80, -10)
