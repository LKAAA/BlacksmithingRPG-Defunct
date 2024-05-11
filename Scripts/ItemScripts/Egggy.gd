extends Item

func use(player):
	print("I do dis instead YIPPIE")
	player.health_manager.fullHeal()
