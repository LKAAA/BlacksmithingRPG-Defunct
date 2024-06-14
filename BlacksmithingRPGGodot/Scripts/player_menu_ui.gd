extends Control

var buttons = []

var currentActiveTab: int = 0

@onready var inventoryUI = $InventorySprite/InventoryHolder

var player: Player

func _ready():
	pass

func get_player(p: Player):
	player = p

func activate_inventory():
	currentActiveTab = 0
	update_inventory()
	self.visible = true

func update_inventory():
	inventoryUI.update_inventory(player)

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

func exit_menu():
	self.visible = false
	player.isMenuOpen = false
