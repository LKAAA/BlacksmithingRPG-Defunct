extends StaticBody2D

@export var character_name: String
@export var dialogue_file: DialogueResource

signal begin_dialogue

func interacted_with() -> void:
	begin_dialogue.emit(dialogue_file, character_name)
