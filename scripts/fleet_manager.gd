extends Node3D


@export var vehicle_scene: PackedScene
@export var num_vehicles: int = 1
@export var gridmap: GridMap

var vehicles: Array[CharacterBody3D] = []
var spawn_timer: Timer

func _ready():
	spawn_initial_fleet()

func spawn_initial_fleet():
	for i in range(num_vehicles):
		spawn_vehicle()

func spawn_vehicle():
	var street_cells = gridmap.get_used_cells()
	if street_cells.size() > 0:
		var vehicle: CharacterBody3D = vehicle_scene.instantiate()
		add_child(vehicle)
		
		var random_cell = street_cells[randi() % street_cells.size()]
		vehicle.global_position = Vector3(random_cell.x, 1, random_cell.z)
		vehicles.append(vehicle)
