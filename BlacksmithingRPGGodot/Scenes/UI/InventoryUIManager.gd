extends GridContainer

var Inventory_Slot_Scene = preload("res://Scenes/UI/inventory_slot.tscn")

var _item_slots = []

@export var itemSlotCount: int = 36

var player: Player

func _ready():
	for _i in itemSlotCount:
		var slot = Inventory_Slot_Scene.instantiate()
		_item_slots.append(slot)
		add_child(slot)

func update_inventory(p: Player):
	player = p
	print("Update the inventory")
	#get all item slots from inventory and update each itemslot ui 
	for item in itemSlotCount:
		if item >= player.inventory._slots.size():
			_item_slots[item].lock()
		else:
			if not player.inventory._slots[item] == null:
				_item_slots[item].set_item(player.inventory._slots[item].item, player.inventory._slots[item].quantity)

func update_slot(slot: int):
	pass
