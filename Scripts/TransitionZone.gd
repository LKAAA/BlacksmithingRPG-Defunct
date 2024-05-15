extends Area2D

@export var scenePath = ""
@onready var timer = $Timer

func _on_body_entered(_body):
	print(_body.name)
	_body.update_player_properties()
	timer.start()

func _on_timer_timeout():
	get_tree().change_scene_to_file(scenePath)
