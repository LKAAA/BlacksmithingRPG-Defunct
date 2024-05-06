extends Node2D

var items = {}

func _ready():
	visible = false
	
	# Put items in a dictionary for quick access
	for child in get_children():
		items[child.name] = child
	
	# Remove items from scene tree so they don't get updated
	while get_child_count() > 0:
		remove_child(get_child(0))
	
	print(items)
	pass


func get_item(item_name):
	if (items.has(item_name)):
		return items[item_name]
