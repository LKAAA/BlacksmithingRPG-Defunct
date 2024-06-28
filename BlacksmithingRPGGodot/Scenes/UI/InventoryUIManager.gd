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
	held_item_slot.position = mousePos
	
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

func update_slot(slot: Inventory_Slot):
	if not slot.item == null:
		itemDescription.text = slot.item.description
		bigItemImage.texture = slot.item.sprite

func select_slot(slot: Inventory_Slot):
	if slotSelected: # if a slot is already selected
		if slot.item == null: # If there is no item in the slot
			#Place the selected item in the new slot
			print("Swapping empty slots")
			var newSlot = _item_slots.find(slot)
			print("curSelectedSlot = " + str(curSelectedSlot) + " newSlot = " + str(newSlot) + " Stackable = " + str(_item_slots[curSelectedSlot].item.stackable))
			player.inventory.swap_slots(curSelectedSlot, newSlot, _item_slots[curSelectedSlot].item.stackable)
			slotSelected = false
			update_inventory(player)
		else: # If there is an item in the slot
			print("Swapping full slots")
			var newSlot = _item_slots.find(slot)
			print("curSelectedSlot = " + str(curSelectedSlot) + " newSlot = " + str(newSlot) + " Stackable = " + str(_item_slots[curSelectedSlot].item.stackable))
			player.inventory.swap_slots(curSelectedSlot, newSlot, _item_slots[curSelectedSlot].item.stackable)
			slotSelected = false
			update_inventory(player)
			# swap the selected item
	else: # if a slot is not already selected
		if slot.item == null: # If there is no item in the slot
			slotSelected = false
			#do nothing you clicked on an empty slot
		else: # If there is an item in the slot
			slotSelected = true
			#Pick up the item
			print(slot.quantity)
			held_item_slot.update_slot(slot)
			curSelectedSlot = _item_slots.find(slot)
			if curSelectedSlot == -1:
				printerr("Slot not found")
				pass
			else:
				print("Selected slot = " + str(curSelectedSlot))
	
	
	
	#attach the sprites image to the mouse
	#remember what item it is
	#detect the next slot clicked
	#if that slot has an item, swap the two
	#if that slot has no item, place the item in that slot
