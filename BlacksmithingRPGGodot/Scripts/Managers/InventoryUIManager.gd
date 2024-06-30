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
var heldItemType: Item
var curSelectedSlot: int = -1
var heldQuantity: int

var oldItem
var oldQuantity

@export var itemSlotCount: int = 36

var player: Player

func _ready():
	for _i in itemSlotCount:
		var slot = Inventory_Slot_Scene.instantiate()
		slot.inventoryUI = self
		_item_slots.append(slot)
		add_child(slot)

func _process(delta):
	mousePos = get_global_mouse_position()
	held_item_slot.position = mousePos - Vector2(8, 8)
	held_item_slot.visible = slotSelected

func update_inventory(p: Player):
	player = p
	#get all item slots from inventory and update each itemslot ui 
	for item in itemSlotCount:
		if item >= player.inventory._slots.size():
			_item_slots[item].lock()
		else:
			if player.inventory._slots[item].item == null:
				_item_slots[item].set_empty()
			else:
				_item_slots[item].set_item(player.inventory._slots[item].item, player.inventory._slots[item].quantity)
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

func update_slot(slot: Inventory_Slot):
	if not slot.item == null:
		itemDescription.text = slot.item.description
		bigItemImage.texture = slot.item.sprite

func select_slot(slot: Inventory_Slot) -> void:
	if slotSelected: # If there is an item  selected
		print("HERE")
		handle_slot_selection(slot)
	else: # If there is no item selected
		if slot.item != null: # Check if the slot has something in it, if it does
			slotSelected = true
			heldQuantity = slot.quantity
			heldItemType = slot.item
			curSelectedSlot = _item_slots.find(slot)
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
		player.inventory.set_item_stack(newSlot, heldItemType, heldQuantity)
		reset_selection_state()
	else:
		if slot.item == _item_slots[curSelectedSlot].item:
			if slot.quantity < slot.item.max_quantity:
				var newSlot = _item_slots.find(slot)
				player.inventory.set_item_stack(newSlot, heldItemType, heldQuantity + _item_slots[newSlot].quantity)
				reset_selection_state()
			else:
				print("Cannot split, stack is full.")
		else:
			swap_items_between_slots(slot)

func handle_regular_selection(slot: Inventory_Slot):
	if slot.item == null: # If there is no item in the slot
		var newSlot = _item_slots.find(slot)
		player.inventory.swap_slots(curSelectedSlot, newSlot, _item_slots[curSelectedSlot].item.stackable)
		reset_selection_state()
	else:
		if _item_slots.find(slot) == curSelectedSlot:
			reset_selection_state()
		else:
			if slot.quantity < slot.item.max_quantity or not slot.item.stackable:
				var newSlot = _item_slots.find(slot)
				player.inventory.swap_slots(curSelectedSlot, newSlot, _item_slots[curSelectedSlot].item.stackable)
				reset_selection_state()
			else:
				print("Cannot swap, target slot is full or item not stackable.")

func reset_selection_state() -> void:
	slotSelected = false
	splittingNewStack = false
	heldQuantity = 0
	_item_slots[curSelectedSlot].put_down()
	curSelectedSlot = -1
	update_inventory(player)

func split_stack(slot: Inventory_Slot) -> void:
	if slotSelected:
		if _item_slots.find(slot) != curSelectedSlot:
			if slot.item != null and slot.item == _item_slots[curSelectedSlot].item:
				if heldQuantity < slot.item.max_quantity:
					heldQuantity += 1
					held_item_slot.update_slot(slot.item, heldQuantity)
					slot.picked_up(1, heldQuantity)
					player.inventory.remove_from_slot(_item_slots.find(slot), 1)
					player.inventory.add_to_slot(curSelectedSlot, 1)
					update_inventory(player)
				else:
					print("Cannot take more, stack is full.")
			else:
				print("Different item or no item in slot.")
		else:
			if splittingNewStack:
				heldQuantity += 1
				held_item_slot.update_slot(slot.item, heldQuantity)
				slot.picked_up(1, heldQuantity)
				player.inventory.remove_from_slot(_item_slots.find(slot), 1)
				update_inventory(player)
	else:
		if slot.item != null:
			slotSelected = true
			if slot.item.stackable and slot.quantity > 1:
				heldItemType = slot.item
				splittingNewStack = true
				curSelectedSlot = _item_slots.find(slot)
				heldQuantity += 1
				slot.picked_up(1, 0)
				held_item_slot.update_slot(slot.item, heldQuantity)
				player.inventory.remove_from_slot(_item_slots.find(slot), 1)
				update_inventory(player)
			else:
				print("Item is not stackable or there's only one item.")
	print("Is splitting new stack = " + str(splittingNewStack))

func swap_items_between_slots(slot: Inventory_Slot) -> void:
	var newSlot = _item_slots.find(slot)
	if curSelectedSlot == -1:
		if oldItem == _item_slots[newSlot].item:
			print("Idk kill yourself")
			player.inventory.set_item_stack(newSlot, oldItem, oldQuantity + _item_slots[newSlot].quantity)
			_item_slots[curSelectedSlot].put_down()
			heldQuantity = 0
			oldQuantity = 0
			oldItem = null
			heldItemType = null
			slotSelected = false
			update_inventory(player)
			curSelectedSlot = -1
			splittingNewStack = false
		else:
			#print("cur Selected Slot = " + _item_slots[curSelectedSlot].item.name)
			print("New Slot = " + _item_slots[newSlot].item.name)
			print("Old item = " + oldItem.name)
			player.inventory.set_item_stack(newSlot, oldItem, oldQuantity)
			oldItem = _item_slots[newSlot].item
			oldQuantity = _item_slots[newSlot].quantity
			print("Option A")
			_item_slots[curSelectedSlot].put_down()
			heldQuantity = oldQuantity
			heldItemType = oldItem
			held_item_slot.update_slot(oldItem, heldQuantity)
			update_inventory(player)
			curSelectedSlot = -1
			splittingNewStack = true
	else:
		oldItem = _item_slots[newSlot].item
		oldQuantity = _item_slots[newSlot].quantity
		player.inventory.set_item_stack(newSlot, _item_slots[curSelectedSlot].item, heldQuantity)
		print("Option B")
		_item_slots[curSelectedSlot].put_down()
		heldQuantity = oldQuantity
		heldItemType = oldItem
		held_item_slot.update_slot(oldItem, heldQuantity)
		update_inventory(player)
		curSelectedSlot = -1
		splittingNewStack = true
	
