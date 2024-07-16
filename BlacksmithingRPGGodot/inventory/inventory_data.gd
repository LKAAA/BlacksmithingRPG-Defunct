extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_datas: Array[SlotData]

func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func grab_new_single_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	var return_slot_data: SlotData
	if slot_data:
		return_slot_data = slot_data.create_single_slot_data()
		if slot_datas[index].quantity < 1:
			slot_datas[index] = null
		inventory_updated.emit(self)
		return return_slot_data
	else:
		return null

func grab_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	if slot_data and grabbed_slot_data.quantity + 1 <= 999:
		grabbed_slot_data.quantity += 1
		slot_data.quantity -= 1
		if slot_datas[index].quantity < 1:
			slot_datas[index] = null
		inventory_updated.emit(self)
		return grabbed_slot_data
	else:
		return grabbed_slot_data

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inventory_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

func create_slot_data(item_data: ItemData, quantity: int) -> void:
	var slot_data: SlotData = SlotData.new()
	
	slot_data.new_slot_data(item_data, quantity)
	
	var index = find_open_slot()
	if not index == -1:
		slot_datas[index] = slot_data
	else:
		print("Drop the item")
	print("Create slot")

func add_item(item_data: ItemData, quantity: int) -> void:
	var slot_data: SlotData = SlotData.new()
	
	slot_data.new_slot_data(item_data, quantity)
	
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			print(slot_data.quantity)
			slot_datas[index].fully_merge_with(slot_data)
			print("Fully merge")
			inventory_updated.emit(self)
			return
	
	for index in slot_datas.size():
		if not slot_datas[index]:
			print("New slot")
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return
	

func find_open_slot() -> int:
	var index = -1
	
	index = slot_datas.find(null, 0)
	
	return index

func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		return 
	
	if slot_data.item_data is ItemDataConsumable:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
	
	PlayerManager.use_slot_data(slot_data)
	
	inventory_updated.emit(self)

func remove_item(item: ItemData, quantity: int = 1) -> void:
	for index in slot_datas.size():
		if slot_datas[index]:
			if slot_datas[index].item_data == item:
				for r in quantity:
					slot_datas[index].quantity -= 1
					if slot_datas[index].quantity < 1:
						slot_datas[index] = null
						if r >= 1:
							remove_item(item, r)
	inventory_updated.emit(self)

func pick_up_slot_data(slot_data: SlotData) -> bool:
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			print(slot_data.quantity)
			slot_datas[index].fully_merge_with(slot_data)
			print("Fully merge")
			inventory_updated.emit(self)
			return true
	
	for index in slot_datas.size():
		if not slot_datas[index]:
			print("New slot")
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
	
	return false

func has_item(item: ItemData) -> bool:
	for index in slot_datas.size():
		if slot_datas[index]:
			if slot_datas[index].item_data == item:
				return true
	return false

func get_item_count(item: ItemData) -> int:
	var itemCount: int = 0
	for index in slot_datas.size():
		if slot_datas[index]:
			if slot_datas[index].item_data == item:
				if slot_datas[index].quantity >= 1:
					itemCount += slot_datas[index].quantity
	return itemCount

func get_slot_data(index: int) -> SlotData:
	return slot_datas[index]

func  on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
