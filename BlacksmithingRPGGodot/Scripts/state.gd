extends Node

# CORE VARIABLES
@export var cur_hour: int = 0
@export var cur_day: String
@export var cur_season: String
@export var is_raining: bool = false


# NPC VARIABLES
@export var has_met_testNPC: bool = false


func has_met(character_name: String) -> bool:
	match character_name:
		"Very Hot Man":
			return has_met_testNPC
	return false
