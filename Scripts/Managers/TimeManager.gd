extends Node

var speed = 13.0

var prev_time = 0.0
var time = 0.0


var second
var minute
var hour
var day
var month
var year

func equals(second, minute, hour, day):
		return self.second == second and self.minute == minute and self.hour == hour and self.day == day

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * speed
	var int_time = int(floor(time))
	
	second = int_time % 60
	minute = (int_time / 60) % 60
	hour = (int_time / (60 * 60)) % 24
	day = (int_time / (60 * 60 * 24))
	
	print("TIME: " + str(hour) + ":" + str(minute) + ":" + str(second))
	
