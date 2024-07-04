extends InteractionManager

@onready var chest: StaticBody2D = $".."

func receive_interaction():
	chest.open_chest()
