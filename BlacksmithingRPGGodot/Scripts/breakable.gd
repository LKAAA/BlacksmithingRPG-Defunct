extends Node2D
class_name Breakable

signal object_clicked
signal destroyed

const PickUp = preload("res://item/pickup/pick_up.tscn")

@export var health: int = 3
@export_enum("Pickaxe", "Axe") var required_tool: String
@export var required_efficiency: int = 1 # The minimum tool efficiency/level required
@export var drop_item: SlotData
@export var break_animation: AnimationPlayer
@export_enum("Mining","Foraging", "Combat", "Leatherworking", 
			"Woodworking", "Forging", "Assembling", 
			"Rune Etching", "Cooking", "Fishing") var xp_reward_type: String
@export var xp_amount: int = 1

func check_harvest(toolType: String, toolStrength: int, tool_damage: int):
	if required_tool == toolType:
		if toolStrength >= required_efficiency:
			take_damage(tool_damage)

func take_damage(tool_damage: int):
	health -= tool_damage
	print(get_parent().name + " took " + str(tool_damage) + " damage. It now has " + str(health) + " health left.")
	if health <= 0:
		break_object()

func break_object():
	if break_animation: 
		break_animation.play("break")
		#implement waiting till it ends
		#probably set up a timer
	drop()
	PlayerManager.give_xp(xp_amount, xp_reward_type)
	destroyed.emit()
	get_parent().queue_free()

func drop():
	print("Drop item")
	var pick_up = PickUp.instantiate()
	var slot_data = drop_item.duplicate(false)
	pick_up.slot_data = slot_data
	pick_up.position = self.get_parent().position
	find_parent("Main").add_child(pick_up)
