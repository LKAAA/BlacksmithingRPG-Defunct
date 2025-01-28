extends ItemData
class_name ItemDataTool

@export_enum("Pickaxe", "Axe") var tool_type: String
@export var tool_efficiency: int = 1
@export var tool_damage: int = 1

func use(target) -> void:
	if Global.can_harvest:
		print("BIG")
		target.harvest(tool_type, tool_efficiency, tool_damage)
