extends Item

@export var tool_type: String # e.g., "pickaxe", "axe", "tongs"
@export var efficiency: int = 1 # Basically the tool level/tier
@export var damage: int = 1
@export var range: int = 1

@export var heldItem: String
