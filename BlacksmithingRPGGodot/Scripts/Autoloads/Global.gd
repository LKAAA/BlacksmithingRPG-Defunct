extends Node

const DEBUG_TEXTURE = preload("res://Assets/Sprites/debug_texture.png")

var main : Main
var player : Player

# CORE VARIABLES
var cur_hour: int = 0
var cur_day: String
var cur_season: String

# Interaction Variables
var can_interact = true
var can_harvest = true

# NPC VARIABLES
var MET_NPCS = {
	"test_npc": false
	}

var game_time_state : Util.GAME_TIME_STATES:
	set(new_game_time_state):
		game_time_state = new_game_time_state
		SignalBus.game_state_changed.emit(game_time_state)
	get():
		return game_time_state
