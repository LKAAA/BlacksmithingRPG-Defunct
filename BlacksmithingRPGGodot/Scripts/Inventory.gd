extends Resource

class_name Inventory

signal slot_changed(index, old_content, new_cont)

var _slots = []

@export var max_slots = 9 : set = _set_max_slots

func _init(max_slots:int = 27):
	self.max_slots = max_slots

func _get_property_list() -> Array:
	return [
		{
			"name": "_slots",
			"type": TYPE_ARRAY,
			"usage": PROPERTY_USAGE_STORAGE
		},
	]

func debug_get_items():
	for i in max_slots:
		if _slots[i].item == null:
			print("Slot %d: %s, 0" % [i, _slots[i].item])
		else:
			print("Slot %d: %s, %d" % [i, _slots[i].item.name, _slots[i].quantity])

func has_item(itemName: String) -> bool:
	var hasItem : = false
	for i in max_slots:
		if _slots[i].item == null:
			continue
		else:
			if _slots[i].item.name == itemName:
				hasItem = true
	return hasItem

func has_item_count(itemName: String) -> int:
	var amount : = 0
	for i in max_slots:
		if _slots[i].item == null:
			continue
		else:
			if _slots[i].item.name == itemName:
				amount = _slots[i].quantity
	return amount

func get_items():
	return _slots

func set_items(items):
	_slots = items

func get_item_stack(index:int):
	assert(index >= 0 and index < _slots.size(), "Slot index is out of bounds")
	return _slots[index]

func set_item_stack(index:int, item:Item, quantity:int):
	assert(index >= 0 and index < _slots.size(), "Slot index is out of bounds")
	var old_content = _slots[index]
	_slots[index] = ItemStack.new(item, quantity)
	emit_signal("slot_changed", index, old_content, _slots[index])

func split_item_stack(index:int, split_percentage:float) -> Dictionary:
	assert(index >= 0 and index < _slots.size(), "Slot index is out of bounds")
	
	split_percentage = clamp(split_percentage, 0, 1)
	var stack = get_item_stack(index)
	if not stack.item or stack.quantity <= 1:
		return {}
	var quantity = stack.quantity
	var splitted_quantity = floor(quantity * split_percentage)
	var min_stack = ItemStack.new(stack.item, splitted_quantity)
	var max_stack = ItemStack.new(stack.item, quantity)
	return{"min_stack": min_stack, "max_stack": max_stack}

func swap_slots(from_index:int, to_index:int, should_stack:bool = true):
	var from_content = get_item_stack(from_index)
	var to_content = get_item_stack(to_index)
	if should_stack and from_content.item == to_content.item:
		var quantity = from_content.quantity + to_content.quantity
		var max_quantity = from_content.item.max_quantity
		if quantity > max_quantity:  
			if to_content.quantity == max_quantity: # straight up swaps the two items
				swap_slots(from_index, to_index, false)
			else: # 
				set_item_stack(to_index, to_content.item, max_quantity)
				quantity -= max_quantity
				set_item_stack(from_index, from_content.item, quantity)
		else: # swaps into the same item thats already there
			set_item_stack(from_index, null, 0)
			set_item_stack(to_index, to_content.item, quantity)
	else: # swaps into nothing
		set_item_stack(from_index, null, 0)
		set_item_stack(to_index, to_content.item, from_content.quantity)

func add_item(item:Item, quantity:int = 1, should_stack:bool = true):
	if not item: 
		printerr("Could not find item")
		return 0
	
	var overflow = 0
	
	var new_quantity = quantity
	
	if should_stack:
		for index in max_slots:
			var slot = get_item_stack(index)
			
			if not slot.item == item:
				continue
			
			new_quantity += slot.quantity
			if new_quantity >= item.max_quantity:
				if not slot.quantity == item.max_quantity:
					#create a stack
					set_item_stack(index, item, item.max_quantity)
				new_quantity -= item.max_quantity
			else:
				set_item_stack(index, item, new_quantity)
				new_quantity = 0
				break
	
	if new_quantity > item.max_quantity:
		while new_quantity > item.max_quantity:
			add_item(item, item.max_quantity, false)
			new_quantity -= item.max_quantity
	
	if new_quantity > 0:
		var found = false
		for index in max_slots:
			var slot = get_item_stack(index)
			if not slot.item:
				set_item_stack(index, item, new_quantity)
				found = true
				break
		if not found: 
			overflow = new_quantity
	
	return overflow

func remove_item(item:Item, quantity:int = 1):
	if not item: 
		printerr("Could not find item")
		return 0
	
	for q in quantity:
		for i in max_slots:
			if _slots[i].item == null:
				continue
			elif not _slots[i].item == item:
				continue
			else:
				_slots[i].quantity -= 1
				if _slots[i].quantity == 0:
					_slots[i].item = null
				quantity -= 1

static func swap_slots_from_inventories(from_inventory:Inventory, from_index:int, to_inventory:Inventory, to_index:int, from_stack:ItemStack = null, to_stack:ItemStack = null) -> void:
	
	if from_stack and to_stack:
		var original_from_stack = from_inventory.get_item_stack(from_index)
		var original_to_stack = to_inventory.get_item_stack(to_index)
		var max_quantity = original_from_stack.item.max_quantity
		var from_quantity = from_stack.quantity
		var to_quantity = to_stack.quantity + original_to_stack.quantity
		if to_quantity > max_quantity:
			from_quantity += to_quantity - max_quantity
			to_quantity = max_quantity
		to_inventory.set_item_stack(to_index, to_stack.item, to_quantity)
		from_inventory.set_item_stack(from_index, from_stack.item, from_quantity)
		
		return
	
	if from_inventory == to_inventory:
		if from_index == to_index:
			return
		
		to_inventory.swap_slots(from_index, to_index)
	elif from_inventory:
		from_stack = from_inventory.get_item_stack(from_index)
		to_stack = to_inventory.get_item_stack(to_index)
		
		if not to_stack.item:
			from_inventory.set_item_stack(from_index, null, 0)
			to_inventory.set_item_stack(to_index, from_stack.item, from_stack.quantity)
		elif not from_stack.item == to_stack.item:
			from_inventory.set_item_stack(from_index, to_stack.item, to_stack.quantity)
			to_inventory.set_item_stack(to_index, from_stack.item, from_stack.quantity)
		else:
			var new_quantity = from_stack.quantity + to_stack.quantity
			if new_quantity > from_stack.item.max_quantity:
				var swap_targets = to_stack.quantity == to_stack.item.max_quantity
				new_quantity -= from_stack.item.max_quantity
				if swap_targets:
					from_inventory.set_item_stack(from_index, from_stack.item, from_stack.item.max_quantity)
					to_inventory.set_item_stack(to_index, to_stack.item, new_quantity)
				else:
					to_inventory.set_item_stack(to_index, to_stack.item, to_stack.item.max_quantity)
					from_inventory.set_item_stack(from_index, from_stack.item, new_quantity)
			else:
				from_inventory.set_item_stack(from_index, null, 0)
				to_inventory.set_item_stack(to_index, to_stack.item, new_quantity)
	else:
		push_error("from_inventory is null and funcionality is not implemented")

func _set_max_slots(new_value: int):
	max_slots = new_value
	
	_slots.resize(max_slots)
	for i in max_slots:
		if _slots[i] and _slots[i].item:
			continue
		else:
			set_item_stack(i, null, 0)
