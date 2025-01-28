extends Node2D

@onready var player = Global.player
@onready var label: Label = $Label

const BASE_TEXT = "[RMB] to "

var active_areas = []

func _ready() -> void:
	SignalBus.interact.connect(_player_interacted)
	SignalBus.request_harvest.connect(_player_requested_harvest)

func register_area(area: Node2D): 
	active_areas.push_back(area)

func unregister_area(area: Node2D):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(delta: float) -> void:
	if active_areas.size() > 0 && Global.can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		if not active_areas[0].action_name == "break": # Really scuffed way of seeing whether or not to show the pop up
			label.text = BASE_TEXT + active_areas[0].action_name
			label.global_position = active_areas[0].global_position
			label.global_position.y -= 36
			label.global_position.x -= label.size.x / 2
			label.show()
	else:
		label.hide()

func _sort_by_distance_to_player(area1,  area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _player_interacted():
	if Global.can_interact:
		if active_areas.size() > 0:
			Global.can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			Global.can_interact = true

func _player_requested_harvest(toolType, toolStrength, tool_damage):
	if active_areas.size() > 0:
		for child in active_areas[0].get_parent().get_children(): 
			if child is Breakable:
				child.check_harvest(toolType, toolStrength, tool_damage)
