extends Node2D

const PickUp = preload("res://item/pickup/pick_up.tscn")

@onready var player: Player = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var player_menu_ui: Control = $UI/InventoryInterface/PlayerMenuUI
@onready var hot_bar_inventory: PanelContainer = $UI/HotBarInventory
@onready var player_stats_interface: Control = $UI/PlayerStatsInterface
@onready var tile_map: TileMap = $TileMap

func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	player_menu_ui.toggle_inventory.connect(toggle_inventory_interface)
	player.stats.updated_stats.connect(update_game_ui)
	player.health_manager.updated_health.connect(update_game_ui)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_equip_inventory_data(player.equip_inventory_data)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	player_stats_interface.update_max_stats(player.health_manager.max_health, player.stats.max_stamina)
	update_game_ui()
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

func _physics_process(delta: float) -> void:
	

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

func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)
