extends CharacterBody3D

@export var speed: float = 3.0
var target_position: Vector3 = Vector3.ZERO
var current_path: Array[Vector3] = []
var current_path_index: int = 0
var pathfinder: PathFinder

func _ready():
	pathfinder = PathFinder.new(get_parent().gridmap)
	set_random_target()

func _process(delta):
	if current_path.is_empty():
		set_random_target()
		return
		
	if current_path_index >= current_path.size():
		set_random_target()
		return
		
	move_along_path(delta)

func set_random_target():
	var cells = get_parent().gridmap.get_used_cells()
	if cells.size() > 0:
		var random_cell = cells[randi() % cells.size()]
		target_position = Vector3(random_cell.x, 1, random_cell.z)
		
		# Calculate new path
		current_path = pathfinder.find_path(global_position, target_position)
		current_path_index = 0

func move_along_path(delta):
	if current_path_index < current_path.size():
		var next_point = current_path[current_path_index]
		var direction = (next_point - global_position).normalized()
		
		# Look in the direction of movement
		if direction != Vector3.ZERO:
			look_at(global_position + direction, Vector3.UP)
		
		velocity = direction * speed
		move_and_slide()
		
		# Check if we've reached the current waypoint
		if global_position.distance_to(next_point) < 0.5:
			current_path_index += 1
