extends Node2D

@onready var npc: NPC_CORE = $".."
var events: Array[ScheduleEvent]

func _ready() -> void:
	events = npc.schedule_events

func query_events():
	Log.print("Querying events")
	for event in events.size():
		if array_contains(State.cur_season, events[event].season):
			#Log.print("Correct Season")
			if array_contains(State.cur_day, events[event].day):
				#Log.print("Correct day")
				if events[event].start_time == State.cur_hour:
					#Log.print("Correct start time")
					if events[event].requires_raining == State.is_raining:
						npc.run_event(events[event].tile_location, events[event].direction)
						Log.print("Commencing")
					else:
						#Log.print("Wrong raining state")
						pass
				else:
					#Log.print("Not start time")
					pass
			else: 
				#Log.print("Not the right day")
				pass
		else:
			#Log.print("Not the right season")
			pass

func array_contains(value, array) -> bool:
	for item in array:
		if item == value: return true
	return false
