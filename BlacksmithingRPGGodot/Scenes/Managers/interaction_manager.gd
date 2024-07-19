extends InteractionManager

@onready var npc_test = $".."

func receive_interaction():
	npc_test.interacted_with()
