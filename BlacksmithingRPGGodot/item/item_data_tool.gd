extends ItemData
class_name ItemDataTool

@export_enum("Pickaxe", "Axe") var tool_type: String
@export var tool_efficiency: int = 1
@export var tool_damage: int = 1

func use(target) -> void:
	#target.harvest(tool_type, tool_efficiency, tool_damage)
	print("Test harvest")
