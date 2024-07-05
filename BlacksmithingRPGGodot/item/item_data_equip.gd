extends ItemData
class_name ItemDataEquip

@export var speed: int
@export var defense: int

func equipped(target) -> void:
	target.speedBonuses += speed

func unequipped(target) -> void:
	target.speedBonuses -= speed
