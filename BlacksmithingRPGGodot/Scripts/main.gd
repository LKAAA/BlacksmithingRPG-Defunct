extends Node2D
class_name Main

const PickUp = preload("res://item/pickup/pick_up.tscn")
@onready var grid: Grid = $TileMap

@onready var player: Player = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var player_menu_ui: Control = $UI/InventoryInterface/PlayerMenuUI
@onready var hot_bar_inventory: PanelContainer = $UI/HotBarInventory
@onready var player_stats_interface: Control = $UI/PlayerStatsInterface
@onready var inventory_section: Control = $UI/InventoryInterface/InventorySection
@onready var equip_inventory: PanelContainer = $UI/InventoryInterface/InventorySection/EquipInventory
@onready var skills_section = $UI/InventoryInterface/SkillsSection
@onready var day_night_cycle_ui: Control = $UI/DayNightCycleUI

var external = false

func _ready() -> void:
	# Global Updates
	Global.main = self
	Global.player = player
	Global.game_time_state = Util.GAME_TIME_STATES.PLAY
	
	# Signal Connections
	SignalBus.toggle_inventory.connect(toggle_inventory_interface)
	SignalBus.change_menu.connect(change_menu)
	SignalBus.updated_stats.connect(update_game_ui)
	SignalBus.updated_health.connect(update_game_ui)
	SignalBus.use_item.connect(use_item)
	SignalBus.time_tick.connect(day_night_cycle_ui.set_daytime)
	
	# Setting Variables
	inventory_interface.set_player_inventory_data(player.inventory_data)
	inventory_interface.set_equip_inventory_data(player.equip_inventory_data)
	hot_bar_inventory.set_inventory_data(player.inventory_data)
	player_stats_interface.update_max_stats(player.health_manager.max_health, player.stats.max_stamina)
	
	update_game_ui()
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	
	var astargrid = AStarGrid2D.new()
	astargrid.size = Vector2i(32, 32)
	astargrid.cell_size = Vector2i(16,16)
	astargrid.update()
	
	astargrid.set_point_solid(Vector2i(0,0), true)

func _physics_process(delta: float) -> void:
	match Global.game_time_state:
		Util.GAME_TIME_STATES.END_OF_DAY:
			# Future go to end of day UI and shit
			if Input.is_key_pressed(KEY_SPACE):
				Global.game_time_state = Util.GAME_TIME_STATES.PLAY

func update_game_ui() -> void:
	player_stats_interface.update_text(player.health_manager.cur_health, player.stats.cur_stamina)

func change_menu(menu_num: int) -> void:
	match menu_num:
		0: # Inventory
			if external == false:
				player_menu_ui.set_normal_inventory()
			else:
				player_menu_ui.set_external_inventory()
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
	Global.game_time_state = Util.GAME_TIME_STATES.PLAY if Global.game_time_state == Util.GAME_TIME_STATES.PAUSED else Util.GAME_TIME_STATES.PAUSED
	
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
