extends TileMap
class_name Grid

@onready var astar_grid: AStar2DGridNode = $"../AStar2DGridNode"
@onready var obstacles: Node = $"../GameObjects"
@onready var selection_indicator: TileMapLayer = $SelectionIndicator

var previousTile
@export var clamped_indicator: bool = false
var interaction_range: int = 2

@onready var player: Player = $"../Player"
var player_tile:Vector2

var lastClicked

# ------------------------------------------------------------------------------
# --- Built_in functions -------------------------------------------------------
# ------------------------------------------------------------------------------

func _ready():
	_disable_obstacles(1)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug"):
		astar_grid.set_enable_debug(!astar_grid.get_enable_debug())
	
	player_tile = local_to_map(Vector2i(player.position.x, player.position.y))
	
	handle_selection_indicator()

# ------------------------------------------------------------------------------
# --- functions ----------------------------------------------------------------
# ------------------------------------------------------------------------------

func _disable_obstacles(margin: float = 0.0) -> void:
	for obstacle in obstacles.get_children():
		_disable_obstacle(obstacle, margin)

func _disable_obstacle(obstacle: Node2D, margin: float = 0.0):
	print(obstacle)
	if obstacle is PhysicsBody2D:
		var coll_shape: CollisionShape2D = obstacle.get_node("CollisionShape2D")
		var shape = coll_shape.shape
		var points: Array[Vector2i] = []

		if shape is CircleShape2D:
			# Call get_id_list_inside_circle to get all point ids inside a circle
			points = astar_grid.get_id_list_inside_circle(
						coll_shape.global_position,
						shape.radius, margin)

		elif shape is RectangleShape2D:
			var shape_rect: Rect2 = shape.get_rect()
			var rect: Rect2 = Rect2(
								shape_rect.position + coll_shape.global_position,
								shape_rect.size)

			# Call get_id_list_inside_rect to get all point ids inside a rectangle
			points = astar_grid.get_id_list_inside_rect(
						rect,
						margin)
		astar_grid.disable_points(points)

# Put selection indicator as a tile at mouse position
func handle_selection_indicator() -> void:
	var mouse = get_global_mouse_position()
	
	#Handle offset grid selector by hand
	mouse.x -= 8
	mouse.y -= 8
	
	var tile = local_to_map(mouse)

	if previousTile:
		selection_indicator.erase_cell(previousTile)
	previousTile = tile
	selection_indicator.set_cell(tile, 1, Vector2i(0,0))

# If clicked tile is within x amount of tiles (interaction range)
func object_clicked(object) -> void:
	var clickedTile = local_to_map(object.position)
	if get_distance(clickedTile, player_tile) <= interaction_range:
		lastClicked = object
		print(lastClicked + " was in range and clicked.")
	else:
		print(lastClicked + " was not in range.")

# Distance between two tiles 
func get_distance(tile1: Vector2i, tile2: Vector2i) -> int:
	var tile1Vector = Vector2(tile1.x, tile1.y)
	var tile2Vector = Vector2(tile2.x, tile2.y)
	var distanceTo = tile1Vector.distance_to(tile2Vector)
	var roundedDistanceTo = roundf(distanceTo)
	return roundedDistanceTo
