extends InventoryData
class_name InventoryDataEquip

var equipped_data: SlotData

func grab_slot_data(index: int) -> SlotData:
	
	if equipped_data:
		PlayerManager.unequip_slot_data(equipped_data)
		equipped_data = null
	
	return super.grab_slot_data(index)

func grab_new_single_slot_data(index: int) -> SlotData:
	
	if equipped_data:
		PlayerManager.unequip_slot_data(equipped_data)
		equipped_data = null
	
	return super.grab_new_single_slot_data(index)

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	
	equipped_data = grabbed_slot_data
	PlayerManager.equip_slot_data(grabbed_slot_data)
	
	return super.drop_slot_data(grabbed_slot_data, index) # Works the exact same

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	
	equipped_data = grabbed_slot_data
	PlayerManager.equip_slot_data(grabbed_slot_data)
	
	return super.drop_single_slot_data(grabbed_slot_data, index) # Works the exact same
