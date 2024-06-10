extends Node2D

@export var note_scene: PackedScene
@export var noteSpawnLocation: Node2D
@export var hitZoneLocation: Node2D
@export var hit_tolerance: float = 100.0  # Adjust as necessary
@export var spawn_interval: float = 1.0

@onready var spawn_timer = $NoteSpawnTimer

@export var total_notes: int = 20  # Set the total number of notes

var score: int = 0
var notes_spawned: int = 0
var notes_processed: int = 0

func _ready():
	start_song()

func start_song():
	#total_notes = XX 
	notes_spawned = 0
	notes_processed = 0
	spawn_interval = 2
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

func stop_song():
	spawn_timer.stop()
	for note in get_children():
		if note is Note:
			note.queue_free()

func generateRandomSpawnInterval():
	var rng = RandomNumberGenerator.new()
	spawn_interval = rng.randf_range(1, 2)

func spawn_note():
	var note_instance = note_scene.instantiate()
	note_instance.position = noteSpawnLocation.position # Adjust as necessary
	add_child(note_instance)

func _input(event):
	if event.is_action_pressed("key_1") or event.is_action_pressed("key_2") or event.is_action_pressed("key_3") or event.is_action_pressed("key_4"):
		check_input(event)

func check_input(event):
	for note in get_children():
		if note is Note:
			if event.is_action_pressed("key_" + str(note.note_type)):
				var distance = note.position.distance_to(hitZoneLocation.position)
				if distance <= hit_tolerance:
					update_score(note.get_score(distance))
					note.queue_free()
					notes_processed += 1
					if notes_processed >= total_notes:
						end_song()

func update_score(hit_score):
	score += hit_score
	#$ScoreLabel.text = str(score)

func _on_note_spawn_timer_timeout():
	if notes_spawned < total_notes:
		generateRandomSpawnInterval()
		spawn_timer.wait_time = spawn_interval
		spawn_note()
		notes_spawned += 1
		spawn_timer.start()
	else:
		spawn_timer.stop()

func end_song():
	stop_song()
	calculate_quality()
	# Add any additional end-of-song logic here (e.g., show a summary screen)

func calculate_quality():
	var max_score = 100
	var possibleScore = max_score * total_notes
	var percentage: float = float(score) / float(possibleScore)
	print("Max Score: " + str(max_score))
	print("Total Notes: " + str(total_notes))
	print("Max Possible Score: " + str(possibleScore))
	print("Score Achieved: " + str(score))
	print("Percentage: " + str(percentage))
	if percentage == 1:
		#rank = SSS (PERFECT)
		print("SSS")
	elif percentage < 1 && percentage >= 0.95:
		#rank = SS
		print("SS")
	elif percentage < 0.95 && percentage >= 0.9:
		#rank = S
		print("S")
	elif percentage < 0.9 && percentage >= 0.75:
		#rank = A
		print("A")
	elif percentage < 0.75 && percentage >= 0.65:
		#rank = B
		print("B")
	elif percentage < 0.65 && percentage >= 0.5:
		#rank = C
		print("C")
	elif percentage < 0.5 && percentage >= 0:
		#FAILED CRAFT
		print("FAILED")
