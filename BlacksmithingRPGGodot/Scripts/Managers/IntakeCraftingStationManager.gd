extends Node
class_name IntakeCraftingStation

signal turnedOn
signal turnedOff

@export var requiredItem: String
@export var craftingRecipies: Array[Recipe]
@onready var timer = $Timer

var chosenRecipe: Recipe
var owedItem: ItemData
var owedCount: int
var owedXP: int
var owedXPType: String
var readyToGrab: bool = false
var isOn: bool = false

var player: Player

func _ready() -> void:
	player = PlayerManager.player

func _process(delta: float) -> void:
	if isOn:
		match Global.game_time_state:
			Util.GAME_TIME_STATES.PLAY:
				if timer.paused == false: timer.paused = true
			Util.GAME_TIME_STATES.PAUSED:
				if timer.paused == true: timer.paused = false

func interactedWith() -> void:
	if readyToGrab == false:
		decide_recipe()
	elif readyToGrab == true:
		attemptGrab()

func can_craft(recipe: Recipe) -> bool:
	for ingredient in recipe.ingredients.size():
		if not player.inventory_data.has_item(recipe.ingredients[ingredient]):
			Log.print("No item")
			return false
		else:
			var ownedItemCount : = player.inventory_data.get_item_count(recipe.ingredients[ingredient])
			if ownedItemCount >= recipe.ingredients.count(recipe.ingredients[ingredient]):
				Log.print("Has item and quantity required")
				Log.print("Quantity = " + str(ownedItemCount))
				return true
			else:
				Log.print("Has item but not enough")
				return false
	Log.print("I hope its not this one")
	return false

func decide_recipe() -> void:
	var chosenRecipe: Recipe
	if not isOn:
		if PlayerManager.active_slot:
			for recipe in craftingRecipies.size():
				var curRecipe : = craftingRecipies[recipe]
				for ingredient in curRecipe.ingredients.size():
					if PlayerManager.active_slot.item_data == curRecipe.ingredients[ingredient]:
						chosenRecipe = curRecipe
						if can_craft(chosenRecipe):
							beginCrafting(chosenRecipe)
						break
					else: 
						chosenRecipe = null
						Log.print("Incorrect Item")
						break
		else:
			chosenRecipe = null
			Log.print("No active item")

func beginCrafting(recipe: Recipe) -> void:
	Log.print("Begin crafting")
	# get player inventory items
	var numOfIngredients = 0
	for ingredient in recipe.ingredients.size():
		numOfIngredients += 1
	player.inventory_data.remove_item(recipe.ingredients[0], numOfIngredients)
	
	owedItem = recipe.craftedItem
	owedCount = recipe.craftedQuantity
	owedXP = recipe.xpReward
	owedXPType = recipe.recipeType
	timer.wait_time = recipe.craftingDuration
	timer.start()
	turnedOn.emit()
	isOn = true

func attemptGrab() -> void:
	finishCraft()

func finishCraft():
	PlayerManager.player.inventory_data.add_item(owedItem, owedCount)
	player.leveling_manager.gainXP(owedXP, owedXPType)
	owedItem = null
	owedCount = 0
	readyToGrab = false
	isOn = false
	Log.print("Grabbed item")

func craftEnded():
	readyToGrab = true
	turnedOff.emit()
	Log.print("ready for pickup")

func _on_timer_timeout():
	craftEnded()
