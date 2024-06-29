extends GridContainer

var Hotbar_Slot_Scene = preload("res://Scenes/UI/hotbar_slot.tscn")

var _item_slots = []

@export var hotbarCount: int = 12

var player: Player

func _ready():
	for _i in hotbarCount:
		var slot = Hotbar_Slot_Scene.instantiate()
		_item_slots.append(slot)
		add_child(slot)

func update_hotbar(p: Player):
	player = p
	print("Update the hotbar")
	#get all item slots from inventory and update each itemslot ui 
	for item in hotbarCount:
		if not player.inventory._slots[item] == null:
			_item_slots[item].set_item(player.inventory._slots[item].item, player.inventory._slots[item].quantity)
			print(_item_slots[item].item)
