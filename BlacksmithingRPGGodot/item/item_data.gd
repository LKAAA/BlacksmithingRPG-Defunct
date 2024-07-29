extends Resource
class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var texture: AtlasTexture

func use(_target) -> void:
	pass

func equipped(_target) -> void:
	pass

func unequipped(_target) -> void:
	pass
