extends Resource
class_name ScheduleEvent

@export var start_time: int
@export var tile_location: Vector2i
@export var direction: int 
@export var requires_raining: bool = false
@export var day: Array[String]
@export var season: Array[String]
