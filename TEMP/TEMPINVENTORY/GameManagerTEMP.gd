extends Node

signal player_initialised

var player

func _process(_delta):
	if not player:
		initialise_player()
		return

func initialise_player():
	player = get_tree().get_root().get_node("/root/TestingWorld/Player")
	if not player:
		#print("Could not find player")
		return
	
	emit_signal("player_initialised", player)
	
	player.inventory.inventory_changed.connect(self._on_player_inventory_changed)
	
	var existing_inventory = load("user://inventory.tres")
	if existing_inventory:
		player.inventory.set_items(existing_inventory.get_items())
	else: # If there isn't an inventory
		pass


func _on_player_inventory_changed(inventory):
	ResourceSaver.save(inventory, "user://inventory.tres")
