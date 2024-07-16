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
