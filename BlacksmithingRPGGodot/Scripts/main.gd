extends Node2D

const PickUp = preload("res://item/pickup/pick_up.tscn")

@onready var player: Player = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var player_menu_ui: Control = $UI/InventoryInterface/PlayerMenuUI
@onready var hot_bar_inventory: PanelContainer = $UI/HotBarInventory
@onready var player_stats_interface: Control = $UI/PlayerStatsInterface
@onready var grid: Grid = $Grid

func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	player_menu_ui.toggle_inventory.connect(toggle_inventory_interface)
	player.stats.updated_stats.connect(update_game_ui)
	player.health_manager.updated_health.connect(update_game_ui)
	player.use_item.connect(use_item)
	player.request_harvest.connect(request_harvest)
	player.request_interaction.connect(request_interaction)
	grid.harvesting.connect(request_harvest)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_equip_inventory_data(player.equip_inventory_data)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	player_stats_interface.update_max_stats(player.health_manager.max_health, player.stats.max_stamina)
	update_game_ui()
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

func update_game_ui() -> void:
	player_stats_interface.update_text(player.health_manager.cur_health, player.stats.cur_stamina)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	player.isMenuOpen = not player.isMenuOpen
	
	if inventory_interface.visible:
		hot_bar_inventory.hide()
	else:
		hot_bar_inventory.show()
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()

func use_item() -> void:
	hot_bar_inventory.use_hot_bar_slot()

func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)

func resetObject():
	grid.lastClicked = null

func request_harvest(toolType: String, tool_efficiency: int, tool_damage: int):
	var requestedObjectInfo
	if grid.lastClicked:
		requestedObjectInfo = grid.lastClicked.get_node("Breakable")
		if not requestedObjectInfo.destroyed.is_connected(resetObject):
			requestedObjectInfo.destroyed.connect(resetObject)
	
	if requestedObjectInfo:
		if requestedObjectInfo.required_tool == toolType:
			if requestedObjectInfo.required_efficiency == tool_efficiency:
				print("Can harvest")
				requestedObjectInfo.take_damage(tool_damage)
			else:
				print("Not a strong enough tool")
		else:
			print("Incorrect tool")
	else:
		print("This object is not breakable")

func request_interaction(object: InteractionManager):
	var requestedObjectInfo
	if grid.check_if_in_interaction_range(object.get_parent().position):
		object.receive_interaction()
	else:
		print("Not in range")
