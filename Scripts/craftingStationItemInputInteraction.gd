extends InteractionManager

@onready var crafting_station = $"../IntakeCraftingStationManager"

func receive_interaction():
	crafting_station.interactedWith(current_interaction.get_parent())
