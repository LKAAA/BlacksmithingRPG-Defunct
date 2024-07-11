extends Node2D

signal harvesting

@onready var base_tilemap: TileMap = $"../BaseTilemap"
@onready var tile_indicator: Sprite2D = $"../SelectedTileIndicator"
@onready var player: Player = $"../Player"

const TILE_SIZE = 16

var grid_objects = []
var player_tile: Vector2i
var interaction_range: int = 2

var lastClicked

var mousePos

@export var clamped_indicator: bool = false

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("grid_object"):
		node.object_clicked.connect(object_clicked)

func _process(delta: float) -> void:
	mousePos = get_global_mouse_position()
	var hoveredTile = base_tilemap.local_to_map(mousePos)
	var hoveredTileWorldPosCenter = Vector2i((hoveredTile.x * TILE_SIZE) + (TILE_SIZE / 2), (hoveredTile.y * TILE_SIZE) + (TILE_SIZE / 2))
	
	if not clamped_indicator:
		tile_indicator.position = hoveredTileWorldPosCenter
	else:
		pass
	
	player_tile = base_tilemap.local_to_map(player.position)

func object_clicked(object) -> void:
	print(object.name)
	var clickedTile = base_tilemap.local_to_map(object.position)
	if get_distance(clickedTile, player_tile) <= interaction_range:
		lastClicked = object
		print(lastClicked)
		#harvesting.emit(object.get_node("Breakable"))
	else:
		print("Not in range")

"""
func request_breaking() -> Breakable:
	var clickedTile = base_tilemap.local_to_map(mousePos)
	var tileWorldPos = Vector2i((clickedTile.x * TILE_SIZE), (clickedTile.y * TILE_SIZE))
	var tileWorldPosCenter = Vector2i((tileWorldPos.x) + (TILE_SIZE / 2), (tileWorldPos.y) + (TILE_SIZE / 2)) 
	
	for i in grid_objects.size():
		var object = grid_objects[i]
		
		if object == null:
			break
		
		var object_origin_tile = base_tilemap.local_to_map(object.position)
		
		if get_distance(object_origin_tile, clickedTile) <= 5:
			var object_tiles = get_object_tiles(object)
			for tile in object_tiles.size():
				if object_tiles[tile] == clickedTile:
					if get_distance(object_tiles[tile], player_tile) <= interaction_range:
						if object.get_node("Breakable"):
							return object.get_node("Breakable")
						else:
							return null
					else:
						#print("Not within 2 tiles")
						break
				else:
					#print("Not this one")
					pass
		else:
			#print("Clicked on a different tile")
			pass
	return null
"""

func get_centered_tile_position(tile: Vector2i) -> Vector2i:
	return Vector2i((tile.x * TILE_SIZE) + (TILE_SIZE / 2), (tile.y * TILE_SIZE) + (TILE_SIZE / 2))

func get_distance(tile1: Vector2i, tile2: Vector2i) -> int:
	var tile1Vector = Vector2(tile1.x, tile1.y)
	var tile2Vector = Vector2(tile2.x, tile2.y)
	var distanceTo = tile1Vector.distance_to(tile2Vector)
	var roundedDistanceTo = roundf(distanceTo)
	return roundedDistanceTo

func get_object_tiles(object) -> Array[Vector2i]:
	var ObjectTiles: Array[Vector2i] = []
	
	var origin_tile = base_tilemap.local_to_map(object.position)
	ObjectTiles.append(origin_tile)
	
	if not object.has_node("GridInfo"):
		push_error("Object does not have grid info")
		return ObjectTiles
	
	var objectHeight = object.get_node("GridInfo").GRID_HEIGHT
	var objectWidth = object.get_node("GridInfo").GRID_WIDTH
	
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

