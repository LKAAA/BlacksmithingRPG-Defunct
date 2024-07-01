extends GridContainer

class_name InventoryUI

var Inventory_Slot_Scene = preload("res://Scenes/UI/inventory_slot.tscn")

@onready var bigItemImage = $"../ItemInfoSection/TextureRect"
@onready var itemDescription = $"../ItemInfoSection/Label"
@onready var held_item_slot = $"../HeldItemSlot"

var _item_slots: Array[Inventory_Slot] = []

var mousePos

var slotSelected: bool = false
var splittingNewStack: bool = false
var heldItem: Item
var previousSlot: int = -1 # -1 = no slot, 0 - X is the slot number
var heldQuantity: int

var oldItem
var oldQuantity

@export var itemSlotCount: int = 36

var player: Player

func _ready():
	create_inventory(itemSlotCount)

func _process(delta):
	mousePos = get_global_mouse_position()
	held_item_slot.position = mousePos - Vector2(8, 8)
	held_item_slot.visible = slotSelected

func create_inventory(slots: int):
	for _i in slots:
		var slot = Inventory_Slot_Scene.instantiate()
		slot.inventoryUI = self
		_item_slots.append(slot)
		add_child(slot)

func update_inventory(p: Player):
	player = p
	#get all item slots from inventory and update each itemslot ui 
	for item in itemSlotCount:
		if item >= player.inventory._slots.size(): # If there locked slots of the player, then lock them
			_item_slots[item].lock()
		else: # If they do not need to be locked
			if player.inventory._slots[item].item == null: # If there is no item unlock them, and set it to empty
				_item_slots[item].unlocked()
				_item_slots[item].set_empty()
			else: # If there is an item, set the slot to that item and quantity
				if  player.inventory._slots[item].quantity != 0:
					_item_slots[item].set_item(player.inventory._slots[item].item, player.inventory._slots[item].quantity)
				else:
					_item_slots[item].set_empty()
	
	player.player_ui.update_hotbar()

func reset_inventory(p: Player):
	player = p
	
	slotSelected = false
	
	for item in itemSlotCount:
		if item >= player.inventory._slots.size():
			_item_slots[item].lock()
		else:
			if player.inventory._slots[item].item == null:
				_item_slots[item].set_empty()
			else:
				_item_slots[item].put_down()
				heldQuantity = 0
				_item_slots[item].set_item(player.inventory._slots[item].item, player.inventory._slots[item].quantity)

func update_tooltip(slot: Inventory_Slot):
	if not slot.item == null:
		itemDescription.text = slot.item.description
		bigItemImage.texture = slot.item.sprite

func select_slot(slot: Inventory_Slot) -> void:
	if slotSelected: # If there is an item  selected
		handle_slot_selection(slot)
	else: # If there is no item selected
		if slot.item != null: # Check if the slot has something in it, if it does
			print("Option A")
			slotSelected = true
			heldQuantity = slot.quantity
			heldItem = slot.item
			previousSlot = _item_slots.find(slot)
			held_item_slot.update_slot(slot.item, heldQuantity)
			slot.picked_up(heldQuantity, heldQuantity)
			update_inventory(player)
	print("Is splitting new stack = " + str(splittingNewStack))

func handle_slot_selection(slot: Inventory_Slot) -> void:
	if splittingNewStack:
		handle_splitting_stack(slot)
		print("Splitting Stack")
	else:
		handle_regular_selection(slot)
		print("Regular selection")

func handle_splitting_stack(slot: Inventory_Slot):
	if slot.item == null:
		var newSlot = _item_slots.find(slot)
		player.inventory.set_item_stack(newSlot, heldItem, heldQuantity)
		reset_selection_state()
	else:
		if slot.item == _item_slots[previousSlot].item:
			if slot.quantity < slot.item.max_quantity:
				print("Option B")
				var newSlot = _item_slots.find(slot)
				player.inventory.set_item_stack(newSlot, heldItem, heldQuantity + _item_slots[newSlot].quantity)
				reset_selection_state()
			else:
				print("Cannot split, stack is full.")
		else:
			swap_items_between_slots(slot)

func handle_regular_selection(slot: Inventory_Slot):
	if slot.item == null: # If there is no item in the slot
		var newSlot = _item_slots.find(slot)
		print(previousSlot)
		player.inventory.swap_slots(previousSlot, newSlot, _item_slots[previousSlot].item.stackable)
		reset_selection_state()
		print("Option F")
	else:
		if _item_slots.find(slot) == previousSlot:
			reset_selection_state()
			print("Option G")
		else:
			if slot.quantity < slot.item.max_quantity or not slot.item.stackable:
				var newSlot = _item_slots.find(slot)
				player.inventory.swap_slots(previousSlot, newSlot, _item_slots[previousSlot].item.stackable)
				_item_slots[newSlot].visualQuantity = player.inventory.get_item_stack(newSlot).quantity
				reset_selection_state()
				print("Option H")
			else:
				print("Cannot swap, target slot is full or item not stackable.")

func reset_selection_state() -> void:
	slotSelected = false
	splittingNewStack = false
	heldQuantity = 0
	_item_slots[previousSlot].put_down()
	previousSlot = -1
	update_inventory(player)

func split_stack(slot: Inventory_Slot) -> void:
	if slotSelected:
		if _item_slots.find(slot) != previousSlot:
			if slot.item != null and slot.item == _item_slots[previousSlot].item:
				if slot.quantity > 1:
					print(slot.quantity)
					if heldQuantity < slot.item.max_quantity:
						print("Option I")
						heldQuantity += 1
						heldItem = slot.item
						held_item_slot.update_slot(slot.item, heldQuantity)
						slot.picked_up(1, heldQuantity)
						player.inventory.remove_from_slot(_item_slots.find(slot), 1)
						player.inventory.add_to_slot(previousSlot, 1)
						update_inventory(player)
					else:
						print("Cannot take more, stack is full.")
				elif slot.quantity == 1:
					print("Option J")
					var slotindex = _item_slots.find(slot)
					heldQuantity += 1
					heldItem = player.inventory.get_item_stack(slotindex).item
					held_item_slot.update_slot(heldItem, heldQuantity)
					slot.picked_up(1, heldQuantity)
					player.inventory.remove_from_slot(_item_slots.find(slot), 1)
					player.inventory.add_to_slot(previousSlot, 1)
					player.inventory.set_item_stack(slotindex, null, 0)
					update_inventory(player)
				else:
					print("I want to die please let this solution work or i will start crying")
			else:
				if slot.quantity > 1:
					if slot.item == heldItem:
						print("Option K")
						heldQuantity += 1
						heldItem = slot.item
						held_item_slot.update_slot(slot.item, heldQuantity)
						slot.picked_up(1, heldQuantity)
						player.inventory.remove_from_slot(_item_slots.find(slot), 1)
						update_inventory(player)
					else:
						print("Different item or no item in slot.")
				elif slot.quantity == 1:
					print("Option L")
					var slotindex = _item_slots.find(slot)
					heldQuantity += 1
					heldItem = player.inventory.get_item_stack(slotindex).item
					held_item_slot.update_slot(heldItem, heldQuantity)
					slot.picked_up(1, heldQuantity)
					player.inventory.remove_from_slot(_item_slots.find(slot), 1)
					player.inventory.add_to_slot(previousSlot, 1)
					player.inventory.set_item_stack(slotindex, null, 0)
					update_inventory(player)
				else:
					print("I want to die please let this solution work or i will start crying")
		else:
			if splittingNewStack:
				print("Option M")
				heldQuantity += 1
				heldItem = slot.item
				held_item_slot.update_slot(slot.item, heldQuantity)
				slot.picked_up(1, heldQuantity)
				player.inventory.remove_from_slot(_item_slots.find(slot), 1)
				update_inventory(player)
	else:
		if slot.item != null:
			slotSelected = true
			if slot.item.stackable and slot.quantity > 1:
				print("Option N")
				heldItem = slot.item
				splittingNewStack = true
				previousSlot = _item_slots.find(slot)
				heldQuantity += 1
				slot.picked_up(1, 0)
				held_item_slot.update_slot(slot.item, heldQuantity)
				player.inventory.remove_from_slot(_item_slots.find(slot), 1)
				update_inventory(player)
			else:
				print("Item is not stackable or there's only one item.")

func swap_items_between_slots(slot: Inventory_Slot) -> void:
	var newSlot = _item_slots.find(slot)
	if previousSlot == -1:
		if oldItem == _item_slots[newSlot].item:
			print("Option C")
			player.inventory.set_item_stack(newSlot, oldItem, oldQuantity + _item_slots[newSlot].quantity)
			_item_slots[previousSlot].put_down()
			heldQuantity = 0
			oldQuantity = 0
			oldItem = null
			heldItem = null
			slotSelected = false
			update_inventory(player)
			previousSlot = -1
			splittingNewStack = false
		else:
			#print("cur Selected Slot = " + _item_slots[previousSlot].item.name)
			print("Option D")
			player.inventory.set_item_stack(newSlot, oldItem, oldQuantity)
			oldItem = _item_slots[newSlot].item
			oldQuantity = _item_slots[newSlot].quantity
			_item_slots[previousSlot].put_down()
			heldQuantity = oldQuantity
			heldItem = oldItem
			held_item_slot.update_slot(oldItem, heldQuantity)
			update_inventory(player)
			previousSlot = -1
			splittingNewStack = true
	else:
		oldItem = _item_slots[newSlot].item
		oldQuantity = _item_slots[newSlot].quantity
		player.inventory.set_item_stack(newSlot, _item_slots[previousSlot].item, heldQuantity)
		print("Option E")
		_item_slots[previousSlot].put_down()
		heldQuantity = oldQuantity
		heldItem = oldItem
		held_item_slot.update_slot(oldItem, heldQuantity)
		update_inventory(player)
		previousSlot = -1
		splittingNewStack = true
