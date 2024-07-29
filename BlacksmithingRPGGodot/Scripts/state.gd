extends Node

# CORE VARIABLES
@export var cur_hour: int = 0
@export var cur_day: String
@export var cur_season: String
@export var is_raining: bool = false


# NPC VARIABLES
@export var has_met_testNPC: bool = false

var active_grid

var previous_hour: int = 5
signal hour_passed



func has_met(character_name: String) -> bool:
	match character_name:
		"Very Hot Man":
			return has_met_testNPC
	return false

func _process(_delta: float) -> void:
	if previous_hour == cur_hour - 1:
		hour_passed.emit()
		previous_hour += 1
