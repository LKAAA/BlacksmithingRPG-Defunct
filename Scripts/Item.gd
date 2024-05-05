extends Sprite2D

class_name item

@export var rarity: int
@export var value: int
@export_multiline var description
@export_enum("Material","Consumable", "Tool", "Weapon", ) var itemType: int

#@export var placeableObject = 00
#@export var placeableSize = Vector2.ZERO
#@export var placeableOnWall: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
