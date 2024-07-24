extends CharacterBody2D
class_name NPC_CORE

@onready var npc_scheduler: Node2D = %NPC_Scheduler

@export var npc_name: String
@export var gender: int = 0 # 0 = Male, 1 = Female
@export var is_child: bool
@export var is_dateable: bool

@export var dialogue_file: DialogueResource

@export var schedule_events: Array[ScheduleEvent]

signal begin_dialogue

func interacted_with() -> void:
	begin_dialogue.emit(dialogue_file, npc_name)

func _ready() -> void:
	State.hour_passed.connect(query_schedule)

func query_schedule() -> void:
	Log.print("This")
	npc_scheduler.query_events()

func run_event(tile_location: Vector2i, Direction: int) -> void:
	self.position = Vector2(0,0)
