# street_system.gd
extends Node3D

@export var street_mesh: PackedScene
@export var gridmap: GridMap
@export var view_camera: Camera3D

var plane: Plane
var building_mode: bool = true

func _ready():
	plane = Plane(Vector3.UP, Vector3.ZERO)

func _process(_delta):
	if Input.is_action_pressed("build"):
		var mouse_pos = get_viewport().get_mouse_position()
		var world_position = plane.intersects_ray(
			view_camera.project_ray_origin(mouse_pos),
			view_camera.project_ray_normal(mouse_pos)
		)
		
		if world_position:
			var grid_pos = Vector3i(round(world_position.x), 0, round(world_position.z))
			place_street(grid_pos)
	
	elif Input.is_action_pressed("demolish"):
		var mouse_pos = get_viewport().get_mouse_position()
		var world_position = plane.intersects_ray(
			view_camera.project_ray_origin(mouse_pos),
			view_camera.project_ray_normal(mouse_pos)
		)
		
		if world_position:
			var grid_pos = Vector3i(round(world_position.x), 0, round(world_position.z))
			remove_street(grid_pos)

func place_street(pos: Vector3i):
	if gridmap.get_cell_item(pos) == -1:  # If cell is empty
		gridmap.set_cell_item(pos, 0)  # 0 is the street mesh ID

func remove_street(pos: Vector3i):
	gridmap.set_cell_item(pos, -1)  # -1 removes the cell
