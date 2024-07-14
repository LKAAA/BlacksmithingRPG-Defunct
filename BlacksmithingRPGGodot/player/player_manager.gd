extends Node

var player

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func equip_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.equipped(player)

func unequip_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.unequipped(player)

func interact(object: InteractionManager) -> void:
	player.interact(object)
