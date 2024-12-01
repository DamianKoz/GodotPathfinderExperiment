class_name PathFinder
extends Node

var gridmap: GridMap

func _init(grid: GridMap):
	gridmap = grid

# Get valid neighbors (adjacent street cells) for a given position
func get_neighbors(pos: Vector3i) -> Array[Vector3i]:
	var neighbors: Array[Vector3i] = []
	var directions = [
		Vector3i(1, 0, 0),  # right
		Vector3i(-1, 0, 0), # left
		Vector3i(0, 0, 1),  # forward
		Vector3i(0, 0, -1)  # back
	]
	
	for dir in directions:
		var next_pos = pos + dir
		if gridmap.get_cell_item(next_pos) != -1:  # Check if there's a street
			neighbors.append(next_pos)
	
	return neighbors

# Calculate path using A* algorithm
func find_path(start: Vector3, end: Vector3) -> Array[Vector3]:
	var start_cell = Vector3i(round(start.x), 0, round(start.z))
	var end_cell = Vector3i(round(end.x), 0, round(end.z))
	
	var open_set = []
	var came_from = {}
	var g_score = {}
	var f_score = {}
	
	open_set.append(start_cell)
	g_score[start_cell] = 0
	f_score[start_cell] = heuristic(start_cell, end_cell)
	
	while open_set.size() > 0:
		var current = get_lowest_f_score(open_set, f_score)
		
		if current == end_cell:
			return reconstruct_path(came_from, current)
		
		open_set.erase(current)
		
		for neighbor in get_neighbors(current):
			var tentative_g_score = g_score[current] + 1
			
			if !g_score.has(neighbor) or tentative_g_score < g_score[neighbor]:
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g_score
				f_score[neighbor] = tentative_g_score + heuristic(neighbor, end_cell)
				
				if !open_set.has(neighbor):
					open_set.append(neighbor)
	
	return []  # No path found

# Manhattan distance heuristic
func heuristic(a: Vector3i, b: Vector3i) -> float:
	return abs(a.x - b.x) + abs(a.z - b.z)

# Get node with lowest f_score from open set
func get_lowest_f_score(open_set: Array, f_score: Dictionary) -> Vector3i:
	var lowest = open_set[0]
	for node in open_set:
		if f_score[node] < f_score[lowest]:
			lowest = node
	return lowest

# Reconstruct path from came_from map
func reconstruct_path(came_from: Dictionary, current: Vector3i) -> Array[Vector3]:
	var path: Array[Vector3] = []
	while came_from.has(current):
		path.push_front(Vector3(current.x, 1, current.z))
		current = came_from[current]
	path.push_front(Vector3(current.x, 1, current.z))
	return path
