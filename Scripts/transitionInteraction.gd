extends InteractionManager

@export var scenePath = ""

func receive_interaction():
	get_tree().change_scene_to_file(scenePath)
