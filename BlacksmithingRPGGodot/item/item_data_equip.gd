extends ItemData
class_name ItemDataEquip

@export var speed: int = 0
@export var defense: int = 0

@export_enum("Helmet", "Chestplate", "Leggings", "Boots") var type: int

func equipped(target) -> void:
	if speed > 0:
		target.speedBonuses += speed
	if defense > 0:
		print("defense increase poggo")

func unequipped(target) -> void:
	if speed > 0:
		target.speedBonuses -= speed
	if defense > 0:
		print("No more defense saddo")
