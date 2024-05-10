extends InteractionManager

@export var scenePath = ""

func receive_interaction():
	current_interaction.get_parent().update_player_properties()
	get_tree().change_scene_to_file(scenePath)
