extends Control

signal toggle_inventory
signal change_menu

const BLANK_PAGE = preload("res://Assets/Sprites/UI/Pages/BlankPage.png")
const INVENTORY_PAGE = preload("res://Assets/Sprites/UI/Pages/InventoryPage.png")
const INVENTORY_PAGE_EXTERNAL = preload("res://Assets/Sprites/UI/Pages/InventoryPageExternal.png")

@onready var inventory_sprite: TextureRect = $InventorySprite

@onready var inventory_button = $InventoryButton
@onready var skills_button = $SkillsButton
@onready var relationships_button = $RelationshipsButton
@onready var quests_button = $QuestsButton
@onready var runes_button = $RunesButton
@onready var collection_button = $CollectionButton
@onready var settings_button = $SettingsButton

var buttons = []

var currentActiveTab: int = 0


var player: Player

func _ready():
	buttons.append(inventory_button)
	buttons.append(skills_button)
	buttons.append(relationships_button)
	buttons.append(quests_button)
	buttons.append(runes_button)
	buttons.append(collection_button)
	buttons.append(settings_button)

func get_player(p: Player):
	player = p

func button_pressed(buttonType: String):
	match buttonType:
		"inventory":
			currentActiveTab = 0
			change_menu.emit(currentActiveTab)
			#activate inventory tab
			#set inventory button to in use
			#set all other buttons to not in use
		"skills":
			currentActiveTab = 1
			change_menu.emit(currentActiveTab)
			print("Skills Pressed")
		"relationships":
			currentActiveTab = 2
			change_menu.emit(currentActiveTab)
			print("Relationships Pressed")
		"quests":
			currentActiveTab = 3
			change_menu.emit(currentActiveTab)
			print("Quests Pressed")
		"runes":
			currentActiveTab = 4
			change_menu.emit(currentActiveTab)
			print("Runes Pressed")
		"collection":
			currentActiveTab = 5
			change_menu.emit(currentActiveTab)
			print("Collection Pressed")
		"settings":
			currentActiveTab = 6
			change_menu.emit(currentActiveTab)
			print("Settings Pressed")
		"close":
			exit_menu()
	update_all_button_textures()

func update_all_button_textures():
	print("Updating")
	for button in buttons.size():
		if buttons[button].tabNumber == currentActiveTab: # If it is the active tab
			buttons[button].set_in_use()
		else:
			buttons[button].set_not_in_use()

func exit_menu():
	toggle_inventory.emit()

func set_external_inventory() -> void:
	inventory_sprite.texture = INVENTORY_PAGE_EXTERNAL

func set_normal_inventory() -> void:
	inventory_sprite.texture = INVENTORY_PAGE

func set_other_menu() -> void:
	inventory_sprite.texture = BLANK_PAGE
