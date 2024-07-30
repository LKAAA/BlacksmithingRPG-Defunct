extends Control

@onready var time_text: Label = $TimeText

func set_daytime(day: int, hour: int, minute: int, cur_weekday: String, cur_season: String, am_pm: String) -> void:
	time_text.text = "%s\n %s, Day: %d\n%02d:%02d %s" % [cur_season, cur_weekday, day, hour, minute, am_pm]
