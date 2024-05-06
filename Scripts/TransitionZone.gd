extends Area2D

@export var scenePath = ""

func _on_body_entered(_body):
	get_tree().change_scene_to_file(scenePath)
