extends ItemData
class_name ItemDataConsumable

@export var heal_value: int

func use(target) -> void:
	if heal_value != 0:
		target.health_manager.heal(heal_value)
