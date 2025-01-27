extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var intake_crafting_station_manager: IntakeCraftingStation = $IntakeCraftingStationManager
@onready var interactable: Interactable = $Interactable

var is_hovering

func _ready() -> void:
	interactable.interact = Callable(self, "_on_interact")
	input_pickable = true

func _on_interact() -> void:
	intake_crafting_station_manager.interactedWith()

func _on_intake_crafting_station_manager_turned_off():
	sprite.play("ForgeOff")

func _on_intake_crafting_station_manager_turned_on():
	sprite.play("ForgeOn")

func _on_behind_adjustment_body_exited(body):
	self.z_index = 1

func _on_behind_adjustment_body_entered(body):
	self.z_index = 3


func _physics_process(delta: float) -> void:
	if is_hovering && not interactable.registered:
		interactable.register()
	elif interactable.registered && !is_hovering:
		interactable.unregister()

func _on_mouse_entered() -> void:
	is_hovering = true

func _on_mouse_exited() -> void:
	is_hovering = false
