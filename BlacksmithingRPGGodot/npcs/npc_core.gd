extends CharacterBody2D
class_name NPC_CORE

@export var npc_name: String
@export var gender: int = 0 # 0 = Male, 1 = Female
@export var is_child: bool
@export var is_dateable: bool

@export var dialogue_file: DialogueResource

signal begin_dialogue

func interacted_with() -> void:
	begin_dialogue.emit(dialogue_file, npc_name)
