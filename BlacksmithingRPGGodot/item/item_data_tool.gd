extends ItemData
class_name ItemDataTool

@export var toolType: String
@export var toolStrength: int = 1

func use(target) -> void:
	print("Test harvest")
