extends InteractionManager

@onready var inventory_manager = $"../inventory_manager"


func receive_interaction():
	print("open chest")
	inventory_manager.add_item("Rusty Axe", 1)
	inventory_manager.debug_get_items()
