extends Control

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
			#activate inventory tab
			#set inventory button to in use
			#set all other buttons to not in use
		"skills":
			currentActiveTab = 1
			print("Skills Pressed")
		"relationships":
			currentActiveTab = 2
			print("Relationships Pressed")
		"quests":
			currentActiveTab = 3
			print("Quests Pressed")
		"runes":
			currentActiveTab = 4
			print("Runes Pressed")
		"collection":
			currentActiveTab = 5
			print("Collection Pressed")
		"settings":
			currentActiveTab = 6
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
	self.visible = false
	player.isMenuOpen = false
