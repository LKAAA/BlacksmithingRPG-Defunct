extends Node

signal game_state_changed(new_state)

# Time Based Signals
signal day_changed(new_day)
signal hour_passed(hour)
signal time_tick(day: int, hour: int, minute: int, cur_weekday: String, cur_season: String, am_pm: String)

# Player Signals
signal toggle_inventory()
signal use_item()
signal request_harvest(tool_type, tool_strength, tool_damage)
signal request_interaction(interaction_manager)
signal update_max_stats(new_health, new_stamina)
signal updated_stats

# Health Manager Signals
signal updated_health
signal takenDamage
signal death
