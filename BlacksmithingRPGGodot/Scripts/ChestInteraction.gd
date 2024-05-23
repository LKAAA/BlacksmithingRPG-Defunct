extends InteractionManager

var inventory: Inventory = Inventory.new()

func _ready():
	inventory.max_slots = 27

func receive_interaction():
	print("open chest")
	inventory.add_item(ItemDatabase.get_item("Rusty Axe"), 1)
	inventory.debug_get_items()
