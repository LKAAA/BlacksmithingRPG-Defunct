extends Area2D

@export var scenePath = ""

func _on_body_entered(_body):
	print(_body.name)
	_body.update_player_properties()
	get_tree().change_scene_to_file(scenePath)
