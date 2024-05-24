extends Node
class_name IntakeCraftingStation

signal turnedOn
signal turnedOff

@export var craftingRecipies: Array[Recipe]
@onready var timer = $Timer

var chosenRecipe: Recipe
var owedItem: Item
var owedCount: int
var owedXP: int
var owedXPType: String
var readyToGrab: bool = false

var player: Player

func can_craft(recipe: Recipe) -> bool:
	var can_craft: = true
	for ingredient in recipe.ingredients.size():
		if not player.inventory.has_item(recipe.ingredients[ingredient].name):
			can_craft = false
		else:
			var ownedItemCount : = player.inventory.has_item_count(recipe.ingredients[ingredient].name)
			if ownedItemCount >= recipe.ingredients.count(recipe.ingredients[ingredient]):
				can_craft = true
				return can_craft
			else:
				can_craft = false
				return can_craft
	return can_craft

func decide_recipe():
	var chosenRecipe: Recipe
	if not player.activeItem.item == null:
		for recipe in craftingRecipies.size():
			var curRecipe : = craftingRecipies[recipe]
			for ingredient in curRecipe.ingredients.size():
				if player.activeItem.item == curRecipe.ingredients[ingredient]:
					chosenRecipe = curRecipe
					if can_craft(chosenRecipe):
						beginCrafting(chosenRecipe)
					break
				else: 
					chosenRecipe = null
					print("No available recipe")
					break
	else:
		chosenRecipe = null
		print("No available recipe")

func beginCrafting(recipe: Recipe):
	# get player inventory items
	for ingredient in recipe.ingredients.size():
		player.inventory.remove_item(recipe.ingredients[ingredient])
	
	owedItem = recipe.craftedItem
	owedCount = recipe.craftedQuantity
	owedXP = recipe.xpReward
	owedXPType = recipe.recipeType
	timer.wait_time = recipe.craftingDuration
	timer.start()
	turnedOn.emit()
	print("Started the smelt")

func craftEnded():
	readyToGrab = true
	turnedOff.emit()
	print("ready for pickup")

func finishCraft():
	player.inventory.add_item(owedItem, owedCount)
	player.leveling_manager.gainXP(owedXP, owedXPType)
	print("Picked up item")
	owedItem = null
	owedCount = 0
	readyToGrab = false

func attemptGrab():
	if player.activeItem.item.name == "Tongs":
		print("You have the required item to pick this up")
		finishCraft()
	else:
		print("You don't have the required item to pick this up")

func interactedWith(p: Player):
	player = p
	if readyToGrab == false:
		decide_recipe()
	elif readyToGrab == true:
		attemptGrab()

func _on_timer_timeout():
	craftEnded()
