extends Node

var holdingStats: bool = false

var curHealth
var curStamina
var maxHealth
var maxStamina

var miningLevel
var foragingLevel
var combatLevel
var leathworkingLevel
var woodworkingLevel
var metalworkingLevel
var assemblingLevel
var runeEtchingLevel
var cookingLevel
var fishingLevel

var _items = Array(): set = set_items, get = get_items
var maxSlots = 9

func set_items(new_items):
	_items = new_items

func get_items():
	return _items
