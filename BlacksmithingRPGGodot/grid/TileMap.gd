extends TileMap

var gridsize_x = 100
var gridsize_y = 100
var Dic = {}

var debug_mode_on = false

func _ready():
	for x in gridsize_x:
		for y in gridsize_y:
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
			#var objects = get_used_cells(1)
			#for object in objects:
				#if object == Vector2i(x,y):
					#obstructed = true
			
			var objects = get_tree().get_nodes_in_group("grid_object")
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

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug"):
		debug_mode_on = true
	
	if debug_mode_on:
		debug_placement_grid()
	
	if Input.is_action_just_pressed("DebugRemove"):
		remove_debug_grid()
		debug_mode_on = false
	
	handle_obstruction()
	handle_selection_indicator()

func get_object_tiles(object) -> Array[Vector2i]:
	var ObjectTiles: Array[Vector2i] = []
	
	var origin_tile = local_to_map(object.position)
	ObjectTiles.append(origin_tile)
	
	if not object.has_node("GridObject"):
		#push_error("Object does not have grid object")
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

func handle_obstruction() -> void:
	for x in gridsize_x:
		for y in gridsize_y:
			Dic[str(Vector2(x,y))] = {
					"BaseType": Dic[str(Vector2(x,y))].BaseType,
					"Position": str(Vector2(x,y)),
					"Obstructed" : false
			}
	
	var objects = get_tree().get_nodes_in_group("grid_object")
	
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
	
	for x in gridsize_x:
		for y in gridsize_y:
			if Dic[str(Vector2(x,y))].Obstructed == false:
				set_cell(1, Vector2(x,y), 2, Vector2(1,0)) # Green tiles
			else:
				set_cell(1, Vector2(x,y), 2, Vector2(0,0)) # Red tiles

func remove_debug_grid() -> void:
	clear_layer(1)

func handle_selection_indicator() -> void:
	var tile = local_to_map(get_global_mouse_position())
	
	for x in gridsize_x: #Erase old selected tile
		for y in gridsize_y:
			erase_cell(2, Vector2(x,y))
	
	if Dic.has(str(tile)): # Select a new tile
		set_cell(2, tile, 1, Vector2i(0,0))
		print(Dic[str(tile)])
