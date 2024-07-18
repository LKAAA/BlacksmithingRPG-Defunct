extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		DialogueManager.show_dialogue_balloon(load("res://dialogue/main.dialogue"), "important_question")
		return
