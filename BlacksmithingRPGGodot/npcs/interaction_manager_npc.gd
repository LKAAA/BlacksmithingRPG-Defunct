extends InteractionManager

@onready var npc: NPC_CORE = $".."

func receive_interaction():
	npc.interacted_with()
