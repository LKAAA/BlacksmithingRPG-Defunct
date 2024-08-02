extends CharacterBody2D
class_name NPC_CORE

@onready var npc_scheduler: Node2D = %NPC_Scheduler

@export var npc_name: String
@export var gender: int = 0 # 0 = Male, 1 = Female
@export var is_child: bool
@export var is_dateable: bool

@export var dialogue_file: DialogueResource

@export var schedule_events: Array[ScheduleEvent]

enum AnimationState {
	IDLE = 0,
	WALK = 1,
}

var AnimationNames = {
	AnimationState.WALK:"Walk",
	AnimationState.IDLE:"Idle",
}

@export var MAX_SPEED = 50

var target_location = Vector2.ZERO
var state = AnimationState.IDLE
var last_move_velocity = Vector2.ZERO
var current_animation = null
var move_direction = Vector2.ZERO
var did_arrive = false

signal begin_dialogue
signal target_reached

func interacted_with() -> void:
	begin_dialogue.emit(dialogue_file, npc_name)

func _ready() -> void:
	State.hour_passed.connect(query_schedule)
	# ensure villagers are initially set to their origin
	set_target_location(position)

func reset():
	state = AnimationState.IDLE
	
func walk():
	state = AnimationState.WALK

func idle():
	state = AnimationState.IDLE
	velocity = Vector2.ZERO
	
func set_target_location(target:Vector2) -> void:
	did_arrive = false
	target_location = target

func _physics_process(delta):
	if not visible:
		return
	
	var move_direction = position.direction_to(target_location)
	velocity = move_direction * MAX_SPEED
	look_at_direction(move_direction)
	
	if not _arrived_at_location():
		move_and_slide()
	elif not did_arrive:
		did_arrive = true
		emit_signal("target_reached")

func look_at_direction(direction:Vector2) -> void:
	direction = direction.normalized()
	move_direction = direction

func _arrived_at_location() -> bool:
	return position.distance_to(target_location) < 8

func _get_direction_string(angle:float) -> String:
	var angle_deg = round(rad_to_deg(angle))
	if angle_deg > -90.0 and angle_deg < 90.0:
		return "Right"
	return "Left"

func query_schedule() -> void:
	Log.print("This")
	npc_scheduler.query_events()

func run_event(tile_location: Vector2i, Direction: int) -> void:
	set_target_location(tile_location)
