extends CharacterBody2D

var activeHotbarSlot: int # 0 - 8, 0 being slot 1, 8 being slot 9
var activeItem

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

func _ready():
	inventory = Inventory.new()
	inventory.max_slots = 9
	activeHotbarSlot = 0
	newGameStats()
	updateUI()
	if PlayerProperties.holdingStats:
		get_player_properties()

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
	
	move_and_slide()
	recieve_inputs()
	play_animations()

func recieve_inputs():
	
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
	
	if Input.is_action_just_pressed("TestAction"):
		# health_manager.damage(10)
		# print("Taken 10 damage.")
		inventory.add_item(ItemDatabase.get_item("Rusty Axe"), 1, false)
		#leveling_manager.gainXP(500, "Mining")
		#leveling_manager.debugLevelAllSkillsMax()
		#leveling_manager.debugShowLevels()
		#leveling_manager.gainXP(500, "Combat")
	
	if Input.is_action_just_pressed("OpenInventory"):
		#var foundItem = ItemDatabase.get_item("Egg")
		#print(foundItem.value)
		#print(foundItem.name)
		#print(foundItem.description)
		print("Inventory button pressed")
		inventory.debug_get_items()
		pass
	
	if Input.is_action_just_pressed("interact"):
		print("init interaction")
		interactionManager.initiate_interaction()
	
	if Input.is_action_just_pressed("scroll_up"):
		if activeHotbarSlot == 0:
			activeHotbarSlot = 8
			print(activeHotbarSlot)
		else:
			activeHotbarSlot -= 1
			print(activeHotbarSlot)
		chooseActiveItem()
	
	if Input.is_action_just_pressed("scroll_down"):
		if activeHotbarSlot == 8:
			activeHotbarSlot = 0
			print(activeHotbarSlot)
		else:
			activeHotbarSlot += 1
			print(activeHotbarSlot)
		chooseActiveItem()

func chooseActiveItem():
	activeItem = inventory.get_item_stack(activeHotbarSlot)
	if activeItem == null:
		print("no item")
	else:
		print(activeItem.item_reference.name)

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
	PlayerProperties.metalworkingLevel = leveling_manager.getSkill("Metalworking").curLevel
	PlayerProperties.assemblingLevel = leveling_manager.getSkill("Assembling").curLevel
	PlayerProperties.runeEtchingLevel = leveling_manager.getSkill("Rune Etching").curLevel
	PlayerProperties.cookingLevel = leveling_manager.getSkill("Cooking").curLevel
	PlayerProperties.fishingLevel = leveling_manager.getSkill("Fishing").curLevel
	PlayerProperties.combatLevel = leveling_manager.getSkill("Combat").curLevel
	PlayerProperties.holdingStats = true

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
	leveling_manager.setSkillLevel(PlayerProperties.metalworkingLevel, "Metalworking")
	leveling_manager.setSkillLevel(PlayerProperties.assemblingLevel, "Assembling")
	leveling_manager.setSkillLevel(PlayerProperties.runeEtchingLevel, "Rune Etching")
	leveling_manager.setSkillLevel(PlayerProperties.cookingLevel, "Cooking")
	leveling_manager.setSkillLevel(PlayerProperties.fishingLevel, "Fishing")
	inventory.set_items(PlayerProperties.get_items())
	
	updateUI()
#endregion
