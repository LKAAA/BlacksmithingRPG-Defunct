extends Resource

class_name Item

@export var name: String
@export var stackable: bool = false
@export var max_quantity: int = 1
@export var quantity: int = 1

@export var sellable: bool = true
@export var value: int
@export_multiline var description
@export_enum("GENERIC","CONSUMABLE", "EQUIPMENT", "QUEST", "TOOL") var itemType: int
@export var sprite : Texture

#@export var placeableObject = 00
#@export var placeableSize = Vector2.ZERO
#@export var placeableOnWall: bool

func use(player:Player) -> void:
	print("No use action defined")
