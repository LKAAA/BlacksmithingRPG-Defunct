extends Node2D

const PickUp = preload("res://item/pickup/pick_up.tscn")

@onready var player: Player = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var player_menu_ui: Control = $UI/InventoryInterface/PlayerMenuUI
@onready var hot_bar_inventory: PanelContainer = $UI/HotBarInventory
@onready var player_stats_interface: Control = $UI/PlayerStatsInterface
@onready var inventory_section: Control = $UI/InventoryInterface/InventorySection
@onready var equip_inventory: PanelContainer = $UI/InventoryInterface/InventorySection/EquipInventory
@onready var skills_section = $UI/InventoryInterface/SkillsSection
#@onready var time_manager: Node = %TimeManager
@onready var grid: Grid = $TileMap
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var day_night_cycle_ui: Control = $UI/DayNightCycleUI

var external = false

func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	player_menu_ui.toggle_inventory.connect(toggle_inventory_interface)
	player_menu_ui.change_menu.connect(change_menu)
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
	canvas_modulate.time_tick.connect(day_night_cycle_ui.set_daytime)
	update_game_ui()
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	
	for node in get_tree().get_nodes_in_group("npcs"):
		node.begin_dialogue.connect(begin_dialogue)
	
	var astargrid = AStarGrid2D.new()
	astargrid.size = Vector2i(32, 32)
	astargrid.cell_size = Vector2i(16,16)
	astargrid.update()
	
	astargrid.set_point_solid(Vector2i(0,0), true)

func update_game_ui() -> void:
	player_stats_interface.update_text(player.health_manager.cur_health, player.stats.cur_stamina)

func change_menu(menu_num: int) -> void:
	match menu_num:
		0: # Inventory
			if external == false:
				Log.print("This")
				player_menu_ui.set_normal_inventory()
			else:
				player_menu_ui.set_external_inventory()
				Log.print("That")
			inventory_section.visible = true
			skills_section.visible = false
		1: # Skill
			player_menu_ui.set_other_menu()
			inventory_section.visible = false
			skills_section.visible = true
			skills_section.update_labels()
		2: # Relationship
			player_menu_ui.set_other_menu()
			inventory_section.visible = false
			skills_section.visible = false
		3: # Quests
			player_menu_ui.set_other_menu()
			inventory_section.visible = false
			skills_section.visible = false
		4: # Runes
			player_menu_ui.set_other_menu()
			inventory_section.visible = false
			skills_section.visible = false
		5: # Collection
			player_menu_ui.set_other_menu()
			inventory_section.visible = false
			skills_section.visible = false
		6: # Settings
			player_menu_ui.set_other_menu()
			inventory_section.visible = false
			skills_section.visible = false

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	player.isMenuOpen = not player.isMenuOpen
	State.time_passing = not State.time_passing
	
	player_menu_ui.update_all_button_textures()
	
	if inventory_section.visible:
		player_menu_ui.set_normal_inventory()
	else:
		player_menu_ui.set_other_menu()
	
	if inventory_interface.visible:
		hot_bar_inventory.hide()
	else:
		hot_bar_inventory.show()
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
		player_menu_ui.set_external_inventory()
		equip_inventory.hide()
		external = true
	else:
		inventory_interface.clear_external_inventory()
		equip_inventory.show()
		external = false

func use_item() -> void:
	hot_bar_inventory.use_hot_bar_slot()

func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)

func resetObject():
	grid.lastClicked = null
	pass

func request_harvest(toolType: String, tool_efficiency: int, tool_damage: int):
	var requestedObjectInfo
	if grid.lastClicked:
		if is_instance_valid(grid.lastClicked):
			requestedObjectInfo = grid.lastClicked.get_node("Breakable")
			if not requestedObjectInfo.destroyed.is_connected(resetObject):
				requestedObjectInfo.destroyed.connect(resetObject)
		else:
			print("Idk")
	
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

func begin_dialogue(dialogue_file: DialogueResource, character_name: String) -> void:
	var dialogue_line_title: String
	Log.print("Starting Dialogue")
	if State.has_met(character_name) == false:
		DialogueManager.show_dialogue_balloon(dialogue_file, "unmet_dialogue")
		Log.print("Unmet Dialogue Check as false")
		return
	
	Log.print("Unmet dialogue check as true")
	#dialogue_line_title = time_manager.cur_season.to_lower() + "_" + time_manager.cur_weekday.substr(0, 3)
	
	DialogueManager.show_dialogue_balloon(dialogue_file, dialogue_line_title)
