extends StaticBody2D

@export var character_name: String
@export var dialogue_file: DialogueResource

func interacted_with() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_file, "test")
