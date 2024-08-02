extends TileMap
class_name Grid

signal harvesting

@export var GRID_WIDTH: int
@export var GRID_HEIGHT: int

@onready var player: Player = $"../Player"

const TILE_SIZE = 16

var grid_objects = []
var player_tile: Vector2i
var interaction_range: int = 2

var lastClicked

var mousePos

var Dic = {}

@export var clamped_indicator: bool = false

func _ready() -> void:
	update_grid_objects()
	State.active_grid = self
	
	for x in GRID_WIDTH:
		for y in GRID_HEIGHT:
			var type: String
			var obstructed: bool = false
			match get_cell_atlas_coords(0, Vector2(x,y)): # Hard coding texture atlas coords
				Vector2i(1,5), Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1):
					type = "Dirt"
					obstructed = false
				Vector2i(2,0), Vector2i(0,4), Vector2i(1,4), Vector2i(2,4), Vector2i(0,5), Vector2i(0, 6), Vector2i(1, 6): 
					type = "Grass"
					obstructed = false
				Vector2i(2, 6), Vector2i(2,5), Vector2i(4,4), Vector2i(5, 4), Vector2i(6,4), Vector2i(4,5), Vector2i(6,5):
					type = "Grass"
					obstructed = false
				Vector2i(4, 6), Vector2i(5,6), Vector2i(6,6), Vector2i(4, 1), Vector2i(4,0), Vector2i(5,1), Vector2i(5,0):
					type = "Grass"
					obstructed = false
				Vector2i(3, 0), Vector2i(2,1), Vector2i(3,1), Vector2i(5,1), Vector2i(7,1), Vector2i(7,0):
					type = "Grass"
					obstructed = false
				Vector2i(5,5), Vector2i(8,4), Vector2i(9,4),Vector2i(10,4), Vector2i(10,5),Vector2i(8,5), Vector2i(9,5), Vector2i(10,6),Vector2i(8,6), Vector2i(9,6):
					type = "Sand"
					obstructed = false
				Vector2i(10,0), Vector2i(11,0), Vector2i(10,1), Vector2i(11,1), Vector2i(12,4), Vector2i(13,4),Vector2i(14,4), Vector2i(12,5),Vector2i(13,5), Vector2i(14,5), Vector2i(12,6),Vector2i(13,6), Vector2i(14,6):
					type = "Water"
					obstructed = true
				_: 
					type = "Uh oh"
					obstructed = true     
			
			var objects = get_tree().get_nodes_in_group("grid_objects")
			for object in objects:
				var origin_tile = local_to_map(object.position)
				if origin_tile == Vector2i(x,y):
					print(object.name)
					print(Vector2i(x,y))
					obstructed = true
				else:
					if object.has_node("GridObject"):
						var objectHeight = object.get_node("GridObject").GRID_HEIGHT
						var objectWidth = object.get_node("GridObject").GRID_WIDTH
						
						var prevTile = origin_tile
						
						var wcounter = objectWidth - 1
						var hcounter = objectHeight - 1
						
						var newX = prevTile.x
						var newY = prevTile.y
						
						for w in objectWidth:
							for h in objectHeight:
								if hcounter != 0:
									newY -= 1
									var nextTile = Vector2i(newX, newY)
									hcounter -= 1
									if nextTile == Vector2i(x,y):
										obstructed = true
								
							if wcounter != 0:
								newX += 1
								hcounter = objectHeight - 1
								newY = prevTile.y
								var nextTile = Vector2i(newX, newY)
								wcounter -= 1
								if nextTile == Vector2i(x,y):
										obstructed = true
			
			Dic[str(Vector2(x,y))] = {
					"BaseType": type,
					"Position": str(Vector2(x,y)),
					"Obstructed" : obstructed
					#"ObjectName" : object,
			}

func _process(_delta: float) -> void:
	mousePos = get_local_mouse_position()
	var hoveredTile = local_to_map(mousePos)
	var hoveredTileWorldPosCenter = Vector2i((hoveredTile.x * TILE_SIZE) + (TILE_SIZE / 2), 
										(hoveredTile.y * TILE_SIZE) + (TILE_SIZE / 2) + (4))
	
	player_tile = local_to_map(player.position)
	
	if Dic.has(str(hoveredTile)):
		handle_selection_indicator()
		#print(Dic[str(hoveredTile)])
	
	if Input.is_action_just_pressed("Debug"):
		debug_placement_grid()
	
	if Input.is_action_just_pressed("DebugRemove"):
		remove_debug_grid()

func handle_selection_indicator() -> void:
	var tile = local_to_map(get_global_mouse_position())
	
	for x in GRID_WIDTH: #Erase old selected tile
		for y in GRID_HEIGHT:
			erase_cell(2, Vector2(x,y))
	
	if Dic.has(str(tile)): # Select a new tile
		set_cell(2, tile, 1, Vector2i(0,0))
		#print(Dic[str(tile)])a

func update_grid_objects() -> void:
	for node in get_tree().get_nodes_in_group("grid_object"):
		if node.has_signal("object_clicked"):
			node.object_clicked.connect(object_clicked)

func object_clicked(object) -> void:
	print(object.name)
	var clickedTile = local_to_map(object.position)
	if get_distance(clickedTile, player_tile) <= interaction_range:
		lastClicked = object
		print(lastClicked)
		#harvesting.emit(object.get_node("Breakable"))
	else:
		print("Not in range")

func get_centered_tile_position(tile: Vector2i) -> Vector2i:
	return Vector2i((tile.x * TILE_SIZE) + (TILE_SIZE / 2), (tile.y * TILE_SIZE)
															 + (TILE_SIZE / 2))

func get_distance(tile1: Vector2i, tile2: Vector2i) -> int:
	var tile1Vector = Vector2(tile1.x, tile1.y)
	var tile2Vector = Vector2(tile2.x, tile2.y)
	var distanceTo = tile1Vector.distance_to(tile2Vector)
	var roundedDistanceTo = roundf(distanceTo)
	return roundedDistanceTo

func check_if_in_interaction_range(objectPos: Vector2) -> bool:
	var objectTile = local_to_map(Vector2i(objectPos.x, objectPos.y))
	if get_distance(objectTile, player_tile) <= interaction_range:
		return true
	else:
		return false

func get_object_tiles(object) -> Array[Vector2i]:
	var ObjectTiles: Array[Vector2i] = []
	
	var origin_tile = local_to_map(object.position)
	ObjectTiles.append(origin_tile)
	
	if not object.has_node("GridObject"):
		print(object.name)
		push_error("Object does not have grid info")
		return ObjectTiles
	
	var objectHeight = object.get_node("GridObject").GRID_HEIGHT
	var objectWidth = object.get_node("GridObject").GRID_WIDTH
	
	var prevTile = origin_tile
	
	var wcounter = objectWidth - 1
	var hcounter = objectHeight - 1
	
	var newX = prevTile.x
	var newY = prevTile.y
	
	for w in objectWidth:
		for h in objectHeight:
			if hcounter != 0:
				newY -= 1
				var nextTile = Vector2i(newX, newY)
				ObjectTiles.append(nextTile)
				hcounter -= 1
			
		if wcounter != 0:
				newX += 1
				hcounter = objectHeight - 1
				newY = prevTile.y
				var nextTile = Vector2i(newX, newY)
				ObjectTiles.append(nextTile)
				wcounter -= 1
	
	return ObjectTiles

func get_all_tiles() -> Array[Vector2i]:
	var all_tiles: Array[Vector2i] = []
	
	for w in GRID_WIDTH:
		for h in GRID_HEIGHT:
			all_tiles.append(Vector2i(w, h))
	
	return all_tiles

func handle_obstruction() -> void:
	for x in GRID_WIDTH:
		for y in GRID_HEIGHT:
			Dic[str(Vector2(x,y))] = {
					"BaseType": Dic[str(Vector2(x,y))].BaseType,
					"Position": str(Vector2(x,y)),
					"Obstructed" : false
			}
	
	var objects = get_tree().get_nodes_in_group("grid_objects")
	
	for object in objects:
		var tiles = get_object_tiles(object)
		for tile in tiles:
			if Dic.has(str(tile)):
				Dic[str(tile)] = {
					"BaseType": Dic[str(tile)].BaseType,
					"Position": str(tile),
					"Obstructed" : true
				}

func debug_placement_grid() -> void:
	clear_layer(1)
	handle_obstruction()
	for x in GRID_WIDTH:
		for y in GRID_HEIGHT:
			if Dic[str(Vector2(x,y))].Obstructed == false:
				set_cell(1, Vector2(x,y), 2, Vector2(1,0)) # Green tiles
			else:
				set_cell(1, Vector2(x,y), 2, Vector2(0,0)) # Red tiles

func remove_debug_grid() -> void:
	clear_layer(1)
