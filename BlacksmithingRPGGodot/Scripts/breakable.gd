extends Node
class_name Breakable

const PickUp = preload("res://item/pickup/pick_up.tscn")

@export var health: int = 3
@export_enum("Pickaxe", "Axe") var required_tool: String
@export var required_efficiency: int = 1 # The minimum tool efficiency/level required
@export var drop_item: SlotData
@export var break_animation: AnimationPlayer

func take_damage(tool_damage: int):
	health -= tool_damage
	if health <= 0:
		break_object()

func break_object():
	if break_animation: 
		break_animation.play("break")
		#implement waiting till it ends
		#probably set up a timer
	drop()
	get_parent().queue_free()

func drop():
	print("Drop item")
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = drop_item
	pick_up.position = self.get_parent().position
	get_parent().get_parent().add_child(pick_up)
