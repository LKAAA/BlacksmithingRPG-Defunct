extends CharacterBody2D
class_name Player

@export var interaction_range: int = 2

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

var isMenuOpen: bool = false

const RUNSPEED = 70.00
const WALKSPEED = 50.00
var speedBonuses: float = 0
var currentSpeed: float = (RUNSPEED + speedBonuses)

var isSprinting = false
var toggleSprint = true

var isInteracting = false

var direction: Vector2 = Vector2(0,0)
var lastDirection

signal toggle_inventory()
signal use_item()
signal request_harvest()
signal request_interaction()
signal update_max_stats()

@onready var leveling_manager = $LevelingManager
@onready var interactionManager = $InteractionManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_manager = $HealthManager
@onready var stats = $PlayerStatsManager
@onready var camera = $Camera2D

func _ready():
	PlayerManager.player = self
	isMenuOpen = false
	newGameStats()
	if PlayerProperties.holdingStats:
		print("YEYARAUYUADS")
		get_player_properties()

func _unhandled_input(_event):
	recieve_inputs()

func _physics_process(_delta):
	direction = get_movement_input()
	velocity = direction * (currentSpeed + speedBonuses)
	velocity = velocity.limit_length(currentSpeed)
	
	if not isMenuOpen:
		move_and_slide() 
		play_animations()

func get_movement_input():
	return Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")

func recieve_inputs():
	# Sprinting
	if toggleSprint:
		if Input.is_action_just_pressed("sprint"):
			isSprinting = !isSprinting
			if isSprinting:
				currentSpeed = RUNSPEED
			else:
				currentSpeed = WALKSPEED
	else:
		if Input.is_action_pressed("sprint"):
			currentSpeed = RUNSPEED
		else:
			currentSpeed = WALKSPEED
	
	if not isMenuOpen:
		if Input.is_action_just_pressed("use_item"):
			print("Use item")
			use_item.emit()
		
		#if Input.is_action_just_pressed("interact"):
			#print("init interaction")
			#interactionManager.initiate_interaction()
	
	if Input.is_action_just_pressed("DebugRemove"):
		Log.print("Toggle time passing")
		State.time_passing = !State.time_passing
		#leveling_manager.gainXP(100, "Mining")
		#leveling_manager.gainXP(100, "Forging")
		#leveling_manager.gainXP(100, "Fishing")
	
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()

func play_animations():
	if direction.y < 0:
		animated_sprite.play("walk_up")
		lastDirection = 1
	elif direction.y > 0: 
		animated_sprite.play("walk_down")
		lastDirection = 2
	elif direction.x > 0:
		animated_sprite.play("walk_right")
		lastDirection = 3
	elif direction.x < 0:
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
	print("Deadge")

func levelup(): # on level up increase max health by 2, and stamina by 3.
	health_manager.increase_max_health(2)
	health_manager.full_heal()
	stats.increase_max_stamina(3)
	stats.full_stamina_restore()
	update_max_stats.emit(health_manager.max_health + 2, stats.max_stamina + 3)

func newGameStats():
	health_manager.max_health = 100
	stats.max_stamina = 200
	health_manager.full_heal()
	stats.full_stamina_restore()

#region Player Properties

func update_player_properties():
	PlayerProperties.cur_health = health_manager.cur_health
	PlayerProperties.cur_stamina = stats.cur_stamina
	PlayerProperties.max_health = health_manager.max_health
	PlayerProperties.max_stamina = stats.max_stamina
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

func get_player_properties():
	health_manager.cur_health = PlayerProperties.cur_health
	stats.cur_stamina = PlayerProperties.cur_stamina
	health_manager.max_health = PlayerProperties.max_health
	stats.max_stamina = PlayerProperties.max_stamina
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
#endregion

func get_drop_position() -> Vector2:
	match lastDirection:
		1:
			return self.position - Vector2(0, 20)
		2:
			return self.position + Vector2(0, 30)
		3:
			return self.position + Vector2(30, 0)
		4:
			return self.position - Vector2(30, 0)
		_:
			return self.position + Vector2(0, 30)

func harvest(toolType: String, toolStrength: int, tool_damage: int) -> void:
	request_harvest.emit(toolType, toolStrength, tool_damage)

func interact(object: InteractionManager) -> void:
	request_interaction.emit(object)
