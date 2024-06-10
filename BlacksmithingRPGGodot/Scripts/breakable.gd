extends Node

@export var health: int = 3
@export var required_tool: String = "pickaxe" # The type of tool required
@export var required_efficiency: int = 1 # The minimum tool efficiency/level required
@export var drop_item: Item
@export var break_animation: AnimationPlayer

func take_damage(tool: Item):
	if tool.tool_type == required_tool and tool.efficicency >= required_efficiency:
		health -= tool.damage
		if health <= 0:
			break_object()
	else:
		print("Tool is not effective")

func break_object():
	if break_animation: 
		break_animation.play("break")
		#implement waiting till it ends
		#probably set up a timer
	drop()
	queue_free()

func drop():
	print("Drop item")
	#if drop_item:
		#var item_instance = drop_item.instance()
		#item_instance.global_position = global_position
		#get_parent().add_child(item_instance)
