extends Area2D
class_name Interactable

@export var action_name: String = "interact"
var in_range: bool = false
var registered = false

var interact: Callable = func():
	pass

func register() -> void:
	if in_range:
		InteractionManager.register_area(self)
		registered = true

func unregister() -> void:
	InteractionManager.unregister_area(self)
	registered = false

func _on_body_entered(body: Node2D) -> void:
	in_range = true

func _on_body_exited(body: Node2D) -> void:
	in_range = false
	unregister()
