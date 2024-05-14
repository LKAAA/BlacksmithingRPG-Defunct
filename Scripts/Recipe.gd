extends Resource

class_name Recipe

@export var craftedItem: Item
@export var craftedQuantity: int = 1
@export var ingredients: Array[Item]
@export var owned: bool = false

@export var craftingDuration: int = 0

@export var xpReward: int = 0

@export_enum("Mining","Foraging", "Leatherworking", "Woodworking", "Forging",
 "Assembling", "Rune Etching", "Combat", "Cooking", "Fishing") var recipeType: String
