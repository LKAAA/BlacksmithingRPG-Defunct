extends InteractionManager

func receive_interaction():
	GameManager.player.inventory.add_item("Rusty Axe", 1)
	get_parent().queue_free()
