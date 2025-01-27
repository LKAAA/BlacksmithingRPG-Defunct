extends StaticBody2D

@onready var interactable: Interactable = $Interactable

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData

var is_hovering

func _ready() -> void:
	interactable.interact = Callable(self, "_on_interact")
	input_pickable = true

func _on_interact() -> void:
	toggle_inventory.emit(self)

func _physics_process(delta: float) -> void:
	if is_hovering && not interactable.registered:
		interactable.register()
	elif interactable.registered && !is_hovering:
		interactable.unregister()

func _on_mouse_entered() -> void:
	is_hovering = true

func _on_mouse_exited() -> void:
	is_hovering = false
