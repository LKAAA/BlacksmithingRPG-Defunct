extends GridContainer

class_name InventoryUI

var Inventory_Slot_Scene = preload("res://Scenes/UI/inventory_slot.tscn")

@onready var bigItemImage = $"../ItemInfoSection/TextureRect"
@onready var itemDescription = $"../ItemInfoSection/Label"

@onready var held_item_slot = $"../HeldItemSlot"

var _item_slots = []

var mousePos

var slotSelected: bool
var curSelectedSlot: int
var heldQuantity: int

@export var itemSlotCount: int = 36

var player: Player

func _ready():
	for _i in itemSlotCount:
		var slot = Inventory_Slot_Scene.instantiate()
		slot.inventoryUI = self
		_item_slots.append(slot)
		add_child(slot)
		slotSelected = false

func _process(delta):
	mousePos = get_global_mouse_position()
	held_item_slot.position = Vector2(mousePos.x - 8, mousePos.y - 8)
	
	if not slotSelected:
		held_item_slot.visible = false
	else:
		held_item_slot.visible = true

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

func select_slot(slot: Inventory_Slot):
	if slotSelected: # if a slot is already selected
		if slot.item == null: # If there is no item in the slot
			#Place the selected item in the new slot
			var newSlot = _item_slots.find(slot)
			player.inventory.swap_slots(curSelectedSlot, newSlot, _item_slots[curSelectedSlot].item.stackable)
			slotSelected = false
			_item_slots[curSelectedSlot].put_down()
			heldQuantity = 0
			update_inventory(player)
		else: # If there is an item in the slot
			if _item_slots.find(slot) == curSelectedSlot:
				var newSlot = _item_slots.find(slot)
				player.inventory.swap_slots(curSelectedSlot, newSlot, _item_slots[curSelectedSlot].item.stackable)
				slotSelected = false
				_item_slots[curSelectedSlot].put_down()
				heldQuantity = 0
				update_inventory(player)
			else:
				if not slot.quantity == slot.item.max_quantity:
					var newSlot = _item_slots.find(slot)
					player.inventory.swap_slots(curSelectedSlot, newSlot, _item_slots[curSelectedSlot].item.stackable)
					slotSelected = false
					_item_slots[curSelectedSlot].put_down()
					heldQuantity = 0
					update_inventory(player)
				elif not slot.item.stackable:
					var newSlot = _item_slots.find(slot)
					player.inventory.swap_slots(curSelectedSlot, newSlot, _item_slots[curSelectedSlot].item.stackable)
					slotSelected = false
					_item_slots[curSelectedSlot].put_down()
					heldQuantity = 0
					update_inventory(player)
				elif slot.quantity == slot.item.max_quantity:
					var newSlot = _item_slots.find(slot)
					player.inventory.swap_slots(curSelectedSlot, newSlot, _item_slots[curSelectedSlot].item.stackable)
					slotSelected = false
					_item_slots[curSelectedSlot].put_down()
					heldQuantity = 0
					update_inventory(player)
			# swap the selected item
	else: # if a slot is not already selected
		if slot.item == null: # If there is no item in the slot
			slotSelected = false
			#do nothing you clicked on an empty slot
		else: # If there is an item in the slot
			slotSelected = true
			#Pick up the item
			heldQuantity = slot.quantity
			held_item_slot.update_slot(slot.item, heldQuantity)
			curSelectedSlot = _item_slots.find(slot)
			#player.inventory.remove_item(slot.item, heldQuantity)
			slot.picked_up(heldQuantity, heldQuantity) # Picks up it all so it
			
			#Visually remove the item from the slot, it stays in the actual inventory
			
			update_inventory(player)
			if curSelectedSlot == -1:
				printerr("Slot not found")
				pass
			else:
				print("Selected slot = " + str(curSelectedSlot))

func split_stack(slot: Inventory_Slot):
	if slotSelected: # If holding an item
		if not _item_slots.find(slot) == curSelectedSlot:
			if slot.item == null: # If clicked on slot has no item
				print("No item to pick up")
			elif slot.item == _item_slots[curSelectedSlot].item: 
				# If there is an item to pick up and it is the same as the one already held
				if heldQuantity == slot.item.max_quantity: # If you are already holding the max stack
					print("Can't take anymore")
				else:
					# TAKE ONE FROM THE STACK
					print("Held quantity: " + str(heldQuantity) + "slot quantity: " + str(slot.visualQuantity))
					heldQuantity += 1
					held_item_slot.update_slot(slot.item, heldQuantity)
					slot.picked_up(1, heldQuantity)
					update_inventory(player)
					player.inventory.remove_from_slot(_item_slots.find(slot), 1)
					player.inventory.add_to_slot(curSelectedSlot, 1)
					player.inventory.debug_get_items()
					# Remove one from the stack
					# Add one to the held quantity
					# Update held icon
					# Update item slot
			else: # If the item is different from the currently held item
				print("This is a different item, cannot grab")
		else:
			print("Original slot picked up from")
	else: # If not holding an item
		if slot.item == null: # If clicked on slot has no item
			print("No item to pick up Part 2")
		else: # If there is an item
			print("Pickup a single item i want to die also kill yourself")
			
			
			#slotSelected = true
			
			#print("Held quantity: " + str(heldQuantity) + "slot quantity: " + str(slot.visualQuantity))
			#heldQuantity += 1
			#held_item_slot.update_slot(slot.item, heldQuantity)
			#slot.picked_up(1, heldQuantity)
			#curSelectedSlot = _item_slots.find(slot)
			#update_inventory(player)
			#player.inventory.remove_from_slot(_item_slots.find(slot), 1)
			#player.inventory.add_item(slot.item, 1, false)
			#print("Pick up the item")
	
