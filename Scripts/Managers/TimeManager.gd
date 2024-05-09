extends Node
var secs_per_hour = 60 * 60
var curr_time
var prev_time
var time_accelerator = 60.0 / 0.7 # 60 game seconds = 0.7 actual seconds
var day = 1
var season = 1
var curWeekday
var curSeason

var timePassing: bool = true

func _ready():
	curr_time = 6 * secs_per_hour # start at 6 am
	decideWeekday()
	decideSeason()

func _process(delta):
	if timePassing:
		curr_time += delta * time_accelerator
	if update_ui_time():
		new_day()
	
func new_day():
	day += 1
	decideWeekday()
	curr_time += 4 * secs_per_hour # add 4 hours (advance from 2am to 6am)
	if day == 29:
		season += 1
		day = 1
		decideWeekday()
		decideSeason()

func decideWeekday():
	match day:
		1,8,15,22:
			curWeekday = "Monday"
		2,9,16,23:
			curWeekday = "Tuesday"
		3,10,17,24:
			curWeekday = "Wednesday"
		4,11,18,25:
			curWeekday = "Thursday"
		5,12,19,26:
			curWeekday = "Friday"
		6,13,20,27:
			curWeekday = "Saturday"
		7,14,21,28:
			curWeekday = "Sunday"

func decideSeason():
	match season:
		1:
			curSeason = "Spring"
		2:
			curSeason = "Summer"
		3: 
			curSeason = "Fall"
		4: 
			curSeason = "Winter"

func update_ui_time() -> bool:
	var n = int(curr_time) 
	if n == prev_time: return false # If n is still the same, dont update
	prev_time = n 
	n = n % (24 * secs_per_hour)
	var hour_24 = n / secs_per_hour
	n %= 3600
	var minute = n / 60 

	var am_pm = "am" if hour_24 < 12 else "pm"
	if hour_24 == 0: hour_24 = 12
	var hour_12 = hour_24
	if hour_12 > 12: hour_12 -= 12

	print("Day %d, %02d:%02d %s" % [day, hour_12, minute, am_pm])
	print("Day: %s, Season: %s" % [curWeekday, curSeason]) 
	return hour_24 == 2
