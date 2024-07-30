extends Node

@onready var time_text = $TimeText

var secs_per_hour = 60 * 60
var cur_time: float
var prev_time: float = 0
var time_accelerator = 60.0 / 0.7 # 60 game seconds = 0.7 actual seconds
var day = 1
var season = 1
var cur_weekday: String
var cur_season: String
var cur_hour: int

var timePassing: bool = true

func _ready():
	cur_time = 6 * secs_per_hour # start at 6 am
	decideWeekday()
	decideSeason()

func _process(delta):
	if timePassing:
		cur_time += delta * time_accelerator
		State.cur_time = cur_time
		State.cur_hour = cur_hour
		
	if update_ui_time():
		new_day()
	
func new_day():
	day += 1
	decideWeekday()
	cur_time += 4 * secs_per_hour # add 4 hours (advance from 2am to 6am)
	if day == 29:
		season += 1
		day = 1
		decideWeekday()
		decideSeason()

func decideWeekday():
	match day:
		1,8,15,22:
			cur_weekday = "Monday"
		2,9,16,23:
			cur_weekday = "Tuesday"
		3,10,17,24:
			cur_weekday = "Wednesday"
		4,11,18,25:
			cur_weekday = "Thursday"
		5,12,19,26:
			cur_weekday = "Friday"
		6,13,20,27:
			cur_weekday = "Saturday"
		7,14,21,28:
			cur_weekday = "Sunday"
	State.cur_day = cur_weekday

func decideSeason():
	match season:
		1:
			cur_season = "Spring"
		2:
			cur_season = "Summer"
		3: 
			cur_season = "Fall"
		4: 
			cur_season = "Winter"
	State.cur_season = cur_season

func update_ui_time() -> bool:
	var n = int(cur_time) 
	if n == prev_time: return false # If n is still the same, dont update
	prev_time = n 
	n = n % (24 * secs_per_hour)
	cur_hour = n / secs_per_hour
	n %= 3600
	var minute = n / 60 

	var am_pm = "am" if cur_hour < 12 else "pm"
	if cur_hour == 0: cur_hour = 12
	var hour_12 = cur_hour
	if hour_12 > 12: hour_12 -= 12
	time_text.text = "%s\n %s, Day: %d\n%02d:%02d %s" % [cur_season, cur_weekday, day, hour_12, minute, am_pm]
	return cur_hour == 2
