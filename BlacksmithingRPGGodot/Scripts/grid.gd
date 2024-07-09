extends Node2D

const CELL_SIZE = Vector2(16, 16)

const GRID_WIDTH = 200
const GRID_HEIGHT = 200

var grid = []

func _ready() -> void:
	initialize_grid()
	set_process_input(true)
	detect_and_add_group_objects()

func initialize_grid():
	for x in range(GRID_WIDTH):
		grid.append([])
		for y in range(GRID_HEIGHT):
			grid[x].append(null) # null being an empty cell

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			var grid_pos = world_to_grid(mouse_pos)
			print(mouse_pos)
			print(grid_pos)
			handle_cell_selection(grid_pos)

func world_to_grid(world_pos: Vector2) -> Vector2:
	return Vector2(floor(world_pos.x / CELL_SIZE.x), floor(world_pos.y / CELL_SIZE.y))

func handle_cell_selection(grid_pos: Vector2) -> void:
	if is_within_grid(grid_pos):
		print("Here")
		var cell_content = grid[grid_pos.x][grid_pos.y]
		print(cell_content)
		if not cell_content == null:
			print("Here part 2")
			interact_with_object(cell_content, grid_pos)

func is_within_grid(grid_pos: Vector2) -> bool:
	return grid_pos.x < GRID_WIDTH and grid_pos.y < GRID_HEIGHT

func interact_with_object(obj, grid_pos: Vector2) -> void:
	if obj.has_method("grid_interact"):
		obj.grid_interact()
	else:
		push_error("Object has no interactaction")

func place_object_in_grid(obj, grid_pos: Vector2):
	if is_within_grid(grid_pos):
		grid[grid_pos.x][grid_pos.y] = obj
		add_child(obj)
		obj.position = grid_pos * CELL_SIZE

# Detect objects in the group and add them to the grid
func detect_and_add_group_objects():
	var objects = get_tree().get_nodes_in_group("grid_object")
	for obj in objects:
		var grid_pos = world_to_grid(obj.position)
		place_object_in_grid(obj, grid_pos)
		print(grid_pos)

#grid[grid_pos.x][grid_pos.y] = null  # Remove the object from the grid after breaking
