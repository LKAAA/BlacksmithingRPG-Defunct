extends Node2D
class_name Grid

signal harvesting

@export var GRID_WIDTH: int
@export var GRID_HEIGHT: int

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
	
	#if Input.is_action_pressed("TestAction"):
		#debug_all_tiles(get_all_tiles())

func object_clicked(object) -> void:
	print(object.name)
	var clickedTile = base_tilemap.local_to_map(object.position)
	if get_distance(clickedTile, player_tile) <= interaction_range:
		lastClicked = object
		print(lastClicked)
		#harvesting.emit(object.get_node("Breakable"))
	else:
		print("Not in range")

func get_centered_tile_position(tile: Vector2i) -> Vector2i:
	return Vector2i((tile.x * TILE_SIZE) + (TILE_SIZE / 2), (tile.y * TILE_SIZE) + (TILE_SIZE / 2))

func get_distance(tile1: Vector2i, tile2: Vector2i) -> int:
	var tile1Vector = Vector2(tile1.x, tile1.y)
	var tile2Vector = Vector2(tile2.x, tile2.y)
	var distanceTo = tile1Vector.distance_to(tile2Vector)
	var roundedDistanceTo = roundf(distanceTo)
	return roundedDistanceTo

func check_if_in_interaction_range(objectPos: Vector2) -> bool:
	var objectTile = base_tilemap.local_to_map(Vector2i(objectPos.x, objectPos.y))
	if get_distance(objectTile, player_tile) <= interaction_range:
		return true
	else:
		return false

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

func get_all_tiles() -> Array[Vector2i]:
	var all_tiles: Array[Vector2i] = []
	
	for w in GRID_WIDTH:
		for h in GRID_HEIGHT:
			all_tiles.append(Vector2i(w, h))
	
	return all_tiles

func debug_all_tiles(tiles: Array[Vector2i]) -> void:
	for tile in tiles.size():
		var new_label = Label.new()
		get_parent().add_child(new_label)
		new_label.text = str(tiles[tile])
		new_label.set("theme_override_font_sizes/font_size", 8)
		new_label.position = base_tilemap.map_to_local(tiles[tile])
