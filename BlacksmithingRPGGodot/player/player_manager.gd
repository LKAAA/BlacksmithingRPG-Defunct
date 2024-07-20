extends Node

var player

var active_slot: SlotData

func set_active_item(slot_data: SlotData) -> void:
	active_slot = slot_data
	if active_slot:
		Log.print(str(active_slot.item_data.name))

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func equip_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.equipped(player)

func unequip_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.unequipped(player)

func interact(object: InteractionManager) -> void:
	player.interact(object)

func give_xp(xp_amount: int, xp_type: String) -> void:
	player.leveling_manager.gainXP(xp_amount, xp_type)

func get_skills() -> Array[String]:
	var levels: Array[String]
	
	levels.append(str(player.leveling_manager.getSkill("Mining").curLevel) + "/10")
	levels.append(str(player.leveling_manager.getSkill("Foraging").curLevel) + "/10")
	levels.append(str(player.leveling_manager.getSkill("Combat").curLevel) + "/10")
	levels.append(str(player.leveling_manager.getSkill("Leatherworking").curLevel) + "/10")
	levels.append(str(player.leveling_manager.getSkill("Woodworking").curLevel) + "/10")
	levels.append(str(player.leveling_manager.getSkill("Forging").curLevel) + "/10")
	levels.append(str(player.leveling_manager.getSkill("Assembling").curLevel) + "/10")
	levels.append(str(player.leveling_manager.getSkill("Rune Etching").curLevel) + "/10")
	levels.append(str(player.leveling_manager.getSkill("Cooking").curLevel) + "/10")
	levels.append(str(player.leveling_manager.getSkill("Fishing").curLevel) + "/10")
	
	return levels

func stop_movement() -> void:
	player.horizontal = 0
	player.vertical = 0
	player.play_animations()
