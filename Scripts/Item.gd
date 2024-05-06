extends Sprite2D

class_name item

@export var rarity: int
@export var value: int
@export_multiline var description
@export_enum("Material","Consumable", "Tool", "Weapon", ) var itemType: int

#@export var placeableObject = 00
#@export var placeableSize = Vector2.ZERO
#@export var placeableOnWall: bool
