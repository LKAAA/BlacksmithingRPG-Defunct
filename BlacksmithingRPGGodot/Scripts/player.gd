extends CharacterBody2D

class_name Player

var isMenuOpen: bool = false

var activeHotbarSlot: int # 0 - 8, 0 being slot 1, 8 being slot 9
var activeItem:ItemStack
var selected_tool: String = ""

const RUNSPEED = 80.00
const WALKSPEED = 50.00

var isSprinting = false
var toggleSprint = true

var isInteracting = false

var horizontal
var vertical
var lastDirection

var inventory:Inventory = null

@onready var leveling_manager = $LevelingManager
@onready var interactionManager = $InteractionManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_manager = $HealthManager
@onready var stats = $PlayerStatsManager
@onready var health_text = $CanvasLayer/HealthText
@onready var stamina_text = $CanvasLayer/StaminaText
@onready var camera = $Camera2D
@onready var player_menu_ui = $CanvasLayer/PlayerMenuUI
@onready var player_ui = $CanvasLayer/PlayerUI

func _ready():
	isMenuOpen = false
	inventory = Inventory.new()
	inventory.max_slots = 12
	activeHotbarSlot = 0
	chooseActiveItem()
	newGameStats()
	updateUI()
	player_menu_ui.visible = false
	player_menu_ui.get_player(self)
	player_ui.get_player(self)
	if PlayerProperties.holdingStats:
		print("YEYARAUYUADS")
		get_player_properties()
	print(activeHotbarSlot)
	player_ui.update_hotbar()
	player_ui.update_active_slot()

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	horizontal = Input.get_axis("walk_left", "walk_right")
	vertical = Input.get_axis("walk_up", "walk_down")
	
	if isSprinting:
		# First check if you are moving in both direction
		if vertical && horizontal: 
			# If you are moving in both direction cap speed so it doesnt move faster diagonally
			velocity.x = horizontal * (RUNSPEED / 1.5)
			velocity.y = vertical * (RUNSPEED / 1.5)
		elif horizontal: # If only moving horizontal you want to slow down vertical to 0
			velocity.x = horizontal * RUNSPEED
			velocity.y = move_toward(velocity.y, 0, RUNSPEED)
		elif vertical: # Same but with vertical and horizontal
			velocity.y = vertical * RUNSPEED
			velocity.x = move_toward(velocity.x, 0, RUNSPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, RUNSPEED)
			velocity.y = move_toward(velocity.y, 0, RUNSPEED)
	else:
		# First check if you are moving in both direction
		if vertical && horizontal: 
			# If you are moving in both direction cap speed so it doesnt move faster diagonally
			velocity.x = horizontal * (WALKSPEED / 1.5)
			velocity.y = vertical * (WALKSPEED / 1.5)
		elif horizontal: # If only moving horizontal you want to slow down vertical to 0
			velocity.x = horizontal * WALKSPEED
			velocity.y = move_toward(velocity.y, 0, WALKSPEED)
		elif vertical: # Same but with vertical and horizontal
			velocity.y = vertical * WALKSPEED
			velocity.x = move_toward(velocity.x, 0, WALKSPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, WALKSPEED)
			velocity.y = move_toward(velocity.y, 0, WALKSPEED)
	
	if not isMenuOpen:
		move_and_slide()
		play_animations()
	
	recieve_inputs()
	

func recieve_inputs():
	
	player_ui.update_active_slot()
	
	if toggleSprint == true: 
		# When you press the sprint button, if not already sprinting, start, and vice versa
		if Input.is_action_just_pressed("sprint") && isSprinting == false:
			isSprinting = true
		elif Input.is_action_just_pressed("sprint") && isSprinting == true:
			isSprinting = false
	else:
		# If you hold down the sprint button, set sprinting to true
		if Input.is_action_pressed("sprint"):
			isSprinting = true
		else:
			isSprinting = false
	
	if Input.is_action_just_pressed("use_item"):
		if not activeItem.item == null:
			match activeItem.item.itemType:
				0: # Generic Item (Does nothing)
					print("This item does nothing.")
				1: # Consumable
					activeItem.item.use(self)
					print(activeItem.item.name)
				2: # Equipment
					activeItem.item.use(self)
					print(activeItem.item.name)
				3: # Quest
					print("This is a quest item")
				4: # TOOL
					print(activeItem.item.tool_type)
					match activeItem.item.tool_type:
						"pickaxe":
							use_tool(activeItem.item.tool_type)
						"axe":
							use_tool(activeItem.item.tool_type)
						"tongs":
							use_tool(activeItem.item.tool_type)
		else:
			print("No active item")
	
	if Input.is_action_just_pressed("TestAction"):
		# health_manager.damage(10)
		# print("Taken 10 damage.")
		inventory.add_item(ItemDatabase.get_item("Iron Ore"), 87, true)
		inventory.add_item(ItemDatabase.get_item("Iron Bar"), 888, true)
		inventory.add_item(ItemDatabase.get_item("Tongs"), 1, false)
		player_menu_ui.update_inventory()
		player_ui.update_hotbar()
		chooseActiveItem()
		#leveling_manager.gainXP(500, "Mining")
		#leveling_manager.debugLevelAllSkillsMax()
		#leveling_manager.debugShowLevels()
		#leveling_manager.gainXP(500, "Combat")
	
	if Input.is_action_just_pressed("OpenInventory"):
		if isMenuOpen == false: #If not open
			print("Inventory button pressed")
			player_menu_ui.activate_inventory()
			#inventory.debug_get_items()
			isMenuOpen = true
			
			#reset to idle
			vertical = 0
			horizontal = 0
			play_animations()
			
		else:
			player_menu_ui.visible = false
			isMenuOpen = false
			chooseActiveItem()
	
	if Input.is_action_just_pressed("interact"):
		print("init interaction")
		interactionManager.initiate_interaction()
	
#region Hotbar Input
	
	
	if Input.is_action_just_pressed("scroll_up"):
		if activeHotbarSlot == 0:
			activeHotbarSlot = 11
			print(activeHotbarSlot)
		else:
			activeHotbarSlot -= 1
			print(activeHotbarSlot)
		player_ui.update_active_slot()
		chooseActiveItem()
	
	if Input.is_action_just_pressed("scroll_down"):
		if activeHotbarSlot == 11:
			activeHotbarSlot = 0
			print(activeHotbarSlot)
		else:
			activeHotbarSlot += 1
			print(activeHotbarSlot)
		player_ui.update_active_slot()
		chooseActiveItem()
	
	if Input.is_action_just_pressed("HotbarSlot1"):
		activeHotbarSlot = 0
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot2"):
		activeHotbarSlot = 1
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot3"):
		activeHotbarSlot = 2
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot4"):
		activeHotbarSlot = 3
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot5"):
		activeHotbarSlot = 4
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot6"):
		activeHotbarSlot = 5
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot7"):
		activeHotbarSlot = 6
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot8"):
		activeHotbarSlot = 7
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot9"):
		activeHotbarSlot = 8
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot10"):
		activeHotbarSlot = 9
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot11"):
		activeHotbarSlot = 10
		player_ui.update_active_slot()
		chooseActiveItem()
		print(activeHotbarSlot)
	
	if Input.is_action_just_pressed("HotbarSlot12"):
		activeHotbarSlot = 11
		player_ui.update_active_slot()
		inventory.add_item(ItemDatabase.get_item("Tongs"), 1)
		chooseActiveItem()
		print(activeHotbarSlot)
#endregion

func chooseActiveItem():
	activeItem = inventory.get_item_stack(activeHotbarSlot)
	if activeItem.item == null:
		print("no item")
	else:
		print(activeItem.item.name)

func play_animations():
	if vertical < 0:
		animated_sprite.play("walk_up")
		lastDirection = 1
	elif vertical > 0: 
		animated_sprite.play("walk_down")
		lastDirection = 2
	elif horizontal > 0:
		animated_sprite.play("walk_right")
		lastDirection = 3
	elif horizontal < 0:
		animated_sprite.play("walk_left")
		lastDirection = 4
	else:
		match lastDirection:
			1:
				animated_sprite.play("idle_up")
			2:
				animated_sprite.play("idle_down")
			3:
				animated_sprite.play("idle_right")
			4:
				animated_sprite.play("idle_left")
			_:
				animated_sprite.play("idle_down")

func _on_health_manager_death():
	print("Oh no this is so sad little bunny died :(")

func _on_health_manager_taken_damage():
	updateUI()

func levelup(): # on level up increase max health by 2, and stamina by 3.
	health_manager.increaseMaxHealth(2)
	health_manager.fullHeal()
	stats.increaseMaxStamina(3)
	stats.fullStaminaRestore()
	updateUI()

func newGameStats():
	health_manager.maxHealth = 100
	stats.maxStamina = 200
	health_manager.fullHeal()
	stats.fullStaminaRestore()

func updateUI():
	health_text.text = "Health: %d/%d" % [health_manager.curHealth, health_manager.maxHealth]
	stamina_text.text = "Stamina: %d/%d" % [stats.curStamina, stats.maxStamina]

#region Player Properties

func update_player_properties():
	PlayerProperties.curHealth = health_manager.curHealth
	PlayerProperties.curStamina = stats.curStamina
	PlayerProperties.maxHealth = health_manager.maxHealth
	PlayerProperties.maxStamina = stats.maxStamina
	PlayerProperties.set_items(inventory.get_items())
	PlayerProperties.miningLevel = leveling_manager.getSkill("Mining").curLevel
	PlayerProperties.foragingLevel = leveling_manager.getSkill("Foraging").curLevel
	PlayerProperties.leathworkingLevel = leveling_manager.getSkill("Leatherworking").curLevel
	PlayerProperties.woodworkingLevel = leveling_manager.getSkill("Woodworking").curLevel
	PlayerProperties.forgingLevel = leveling_manager.getSkill("Forging").curLevel
	PlayerProperties.assemblingLevel = leveling_manager.getSkill("Assembling").curLevel
	PlayerProperties.runeEtchingLevel = leveling_manager.getSkill("Rune Etching").curLevel
	PlayerProperties.cookingLevel = leveling_manager.getSkill("Cooking").curLevel
	PlayerProperties.fishingLevel = leveling_manager.getSkill("Fishing").curLevel
	PlayerProperties.combatLevel = leveling_manager.getSkill("Combat").curLevel
	PlayerProperties.holdingStats = true
	PlayerProperties.curActiveSlot = activeHotbarSlot

func get_player_properties():
	health_manager.curHealth = PlayerProperties.curHealth
	stats.curStamina = PlayerProperties.curStamina
	health_manager.maxHealth = PlayerProperties.maxHealth
	stats.maxStamina = PlayerProperties.maxStamina
	leveling_manager.setSkillLevel(PlayerProperties.miningLevel, "Mining")
	leveling_manager.setSkillLevel(PlayerProperties.foragingLevel, "Foraging")
	leveling_manager.setSkillLevel(PlayerProperties.combatLevel, "Combat")
	leveling_manager.setSkillLevel(PlayerProperties.leathworkingLevel, "Leatherworking")
	leveling_manager.setSkillLevel(PlayerProperties.woodworkingLevel, "Woodworking")
	leveling_manager.setSkillLevel(PlayerProperties.forgingLevel, "Forging")
	leveling_manager.setSkillLevel(PlayerProperties.assemblingLevel, "Assembling")
	leveling_manager.setSkillLevel(PlayerProperties.runeEtchingLevel, "Rune Etching")
	leveling_manager.setSkillLevel(PlayerProperties.cookingLevel, "Cooking")
	leveling_manager.setSkillLevel(PlayerProperties.fishingLevel, "Fishing")
	inventory.set_items(PlayerProperties.get_items())
	activeHotbarSlot = PlayerProperties.curActiveSlot
	
	updateUI()
#endregion

func use_tool(toolType: String):
	print("Using " + toolType)

func zoom_out_camera():
	camera.zoom.x = 2.5
	camera.zoom.y = 2.5
	print("Zoom")

func zoom_in_camera():
	camera.zoom.x = 3.5
	camera.zoom.y = 3.5
	print("Unzoom")
