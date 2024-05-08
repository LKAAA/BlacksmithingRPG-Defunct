extends Node

@export var _items = Array(): set = set_items, get = get_items

func set_items(new_items):
	_items = new_items

func get_items():
	return _items

func get_item(index):
	return _items[index]

func debug_get_items():
	print("-- " + get_parent().name + " INVENTORY --")
	for i in range(_items.size()):
		var curItem = _items[i]
		print("ITEM SLOT " + str(i) + ": ITEM NAME: " + curItem.item_reference.name 
		+ " QUANTITY: " + str(curItem.quantity))

func add_item(item_name, quantity):
	# Checks for a positive quantity
	if quantity <= 0: 
		print("Can't add a negative number of items")
		return
	
	# Check if the item actually exists
	var item = ItemDatabase.get_item(item_name)
	if not item: 
		print("Could not find item")
		return
	
	# Determine quantity and stack size / if even stackable
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size if item.stackable else 1
	
	# If item is stackable, then loop through inventory to check 
	# if there is an available stack that is not at stack cap
	if item.stackable:
		for i in range(_items.size()):
			if remaining_quantity == 0:
				break
			
			var inventory_item = _items[i]
			
			if inventory_item.item_reference.name != item.name:
				continue
			
			if inventory_item.quantity < max_stack_size:
				var original_quantity = inventory_item.quantity
				inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= inventory_item.quantity - original_quantity
		
		#Creates a new stack
	while remaining_quantity > 0:
		var new_item = {
			item_reference = item, 
			quantity = min(remaining_quantity, max_stack_size)
		}
		_items.append(new_item)
		remaining_quantity -= new_item.quantity

func clear_inventory():
	_items.clear()

func remove_item(item_name, quantityToRemove):
	if _items.is_empty():
		print("Inventory Empty")
	
	# Check if the quantity is a positive number
	if quantityToRemove <= 0: 
		print("Can't add a negative number of items")
		return
	
	# Check if the item name exists in the database
	var item = ItemDatabase.get_item(item_name)
	if not item: 
		print("Could not find item")
		return
	
	# Check if item is in inventory
	for i in range(_items.size()):
		var inventory_item = _items[i]
			
		if inventory_item.item_reference.name != item.name: #Wrong item, continue looking
			continue
		
		#Correct item
		if quantityToRemove > inventory_item.quantity:
			print("You requested to remove more items than held in the inventory")
			break
		else:
			var original_quantity = inventory_item.quantity
			inventory_item.quantity = max(original_quantity - quantityToRemove, 0)
			if(inventory_item.quantity == 0):
				_items.remove_at(i)
