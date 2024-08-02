extends CanvasModulate

@export var gradient: GradientTexture1D
@export var INGAME_SPEED = 10.0 # 1 ingame second per 1 real life second
@export var INITIAL_HOUR = 6:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

var season: int
var day
var cur_weekday: String
var cur_season: String
var am_pm: String
var hour
var hour_12
var minute

var time: float = 0.0
var past_minute: float = -1.0
var past_hour: float = -1.0

signal time_tick(day: int, hour: int, minute: int)

func _ready() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR
	season = 1
	day = 1
	decideSeason()
	decideWeekday()

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("debug_slow_down_time"):
		if INGAME_SPEED > 5:
			INGAME_SPEED -= 5
		else:
			INGAME_SPEED = 1
	
	if Input.is_action_just_pressed("debug_speed_up_time"):
			INGAME_SPEED += 5

	if State.time_passing:
		time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
		var value = (sin (time - PI / 2) + 1.0) / 2.0
		if am_pm == "am":
			self.color = gradient.gradient.sample(value - 0.1) # Make it a tiny bit darker in the morning
		if am_pm == "pm":
			self.color = gradient.gradient.sample(value + 0.1) # Delay it getting dark by a tiny bit
		
		_recalculate_time()
		
		if am_pm == "am" && hour == 2:
			Log.print("Day ends")
			new_day()
			State.time_passing = false

func _recalculate_time() -> void:
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	
	#day = int(total_minutes / MINUTES_PER_DAY)
	
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	
	hour = int(current_day_minutes / MINUTES_PER_HOUR)
	minute = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if day == 30:
		season += 1
		day = 0
	
	if past_minute != minute:
		past_minute = minute
		_calculate_display_time()

func _calculate_display_time() -> void:
	var display_hour: int
	match hour:
		1:
			display_hour = 1
			am_pm = "am"
		2:
			display_hour = 2
			am_pm = "am"
		3:
			display_hour = 3
			am_pm = "am"
		4:
			display_hour = 4
			am_pm = "am"
		5:
			display_hour = 5
			am_pm = "am"
		6:
			display_hour = 6
			am_pm = "am"
		7:
			display_hour = 7
			am_pm = "am"
		8:
			display_hour = 8
			am_pm = "am"
		9:
			display_hour = 9
			am_pm = "am"
		10:
			display_hour = 10
			am_pm = "am"
		11:
			display_hour = 11
			am_pm = "am"
		12:
			display_hour = 12
			am_pm = "am"
		13:
			display_hour = 1
			am_pm = "pm"
		14:
			display_hour = 2
			am_pm = "pm"
		15:
			display_hour = 3
			am_pm = "pm"
		16:
			display_hour = 4
			am_pm = "pm"
		17:
			display_hour = 5
			am_pm = "pm"
		18:
			display_hour = 6
			am_pm = "pm"
		19:
			display_hour = 7
			am_pm = "pm"
		20:
			display_hour = 8
			am_pm = "pm"
		21:
			display_hour = 9
			am_pm = "pm"
		22:
			display_hour = 10
			am_pm = "pm"
		23:
			display_hour = 11
			am_pm = "pm"
		24:
			display_hour = 12
			am_pm = "pm"
		_:
			display_hour = 12
			am_pm = "am"
	decideWeekday()
	decideSeason()
	if State.cur_hour != display_hour:
		print("This")
		State.cur_hour = display_hour
	time_tick.emit(day, display_hour, minute, cur_weekday, cur_season, am_pm)

func new_day():
	time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR
	day += 1
	decideWeekday()
	if day == 29:
		season += 1
		day = 1
		decideWeekday()
		decideSeason()
	_calculate_display_time()

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

func update_ui_time() -> void:
	var n = int(time) 
	if n == past_minute: return # If n is still the same, dont update
	past_minute = n 
	
	var am_pm = "am" if hour < 12 else "pm"
	if hour == 0: hour = 12
	hour_12 = hour
	if hour_12 > 12: hour_12 -= 12
