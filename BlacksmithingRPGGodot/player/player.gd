extends CharacterBody2D
class_name Player

# Nodes
@onready var leveling_manager = $LevelingManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_manager = $HealthManager
@onready var stats = $PlayerStatsManager
@onready var camera = $Camera2D

# Variables
@export var interaction_range: int = 2
@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip
var toolDamage = 0
var toolStrength = 0
var toolType = ""

# Movement Variables

const RUNSPEED = 70.00
const WALKSPEED = 50.00

var state = {
	"is_sprinting": false,
	"toggle_sprint": true,
	"direction": Vector2.ZERO,
	"last_direction": 2,  # Default to idle_down
	"current_speed": RUNSPEED,
	"speed_bonuses": 0
}

var player_state = Util.PLAYER_STATES.MOVE  # Default player state

func _ready():
	PlayerManager.player = self
	_initialize_player()
	
	SignalBus.connect("game_state_changed", _on_game_state_changed)

func _physics_process(_delta):
	match Global.game_time_state:
		Util.GAME_TIME_STATES.PLAY:
			match player_state:
				Util.PLAYER_STATES.MOVE:
					_handle_movement()
					_handle_input()
					_handle_animations()
					_handle_inventory_input()
				Util.PLAYER_STATES.USE:
					_handle_use_state()
		Util.GAME_TIME_STATES.PAUSED:
			_handle_inventory_input()
	

func _handle_movement():
	state["direction"] = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	velocity = state["direction"] * (state["current_speed"] + state["speed_bonuses"])
	velocity = velocity.limit_length(state["current_speed"] + state["speed_bonuses"])
	move_and_slide() 

func _handle_input():
	# Handle Sprint Toggling
	if state["toggle_sprint"] and Input.is_action_just_pressed("sprint"):
		state["is_sprinting"] = !state["is_sprinting"]
		state["current_speed"] = RUNSPEED if state["is_sprinting"] else WALKSPEED
	else:
		if Input.is_action_pressed("sprint"):
			state["current_speed"] = RUNSPEED if state["is_sprinting"] else WALKSPEED
	
	if Input.is_action_just_pressed("use_item"):
		print(PlayerManager.active_slot.item_data.item_type)
		if PlayerManager.active_slot.item_data.item_type == "Tool" or PlayerManager.active_slot.item_data.item_type == "Consumable" or PlayerManager.active_slot.item_data.item_type == "Weapon":
			player_state = Util.PLAYER_STATES.USE
	
	if Input.is_action_just_pressed("interact"):
		SignalBus.interact.emit()
	
	if Input.is_action_just_pressed("DebugRemove"):
		Log.print("Toggle time passing")
		SignalBus.game_state_changed.emit(Util.GAME_TIME_STATES.PAUSED if Global.game_time_state == Util.GAME_TIME_STATES.PLAY else Util.GAME_TIME_STATES.PLAY)

func _handle_inventory_input():
	if Input.is_action_just_pressed("inventory"):
		SignalBus.toggle_inventory.emit()

func _handle_animations():
	if state["direction"].y < 0:
		animated_sprite.play("walk_up")
		state["last_direction"] = 1
	elif state["direction"].y > 0:
		animated_sprite.play("walk_down")
		state["last_direction"] = 2
	elif state["direction"].x > 0:
		animated_sprite.play("walk_right")
		state["last_direction"] = 3
	elif state["direction"].x < 0:
		animated_sprite.play("walk_left")
		state["last_direction"] = 4
	else:
		_play_idle_animation()

func _play_idle_animation() -> void:
	match state["last_direction"]:
		1: animated_sprite.play("idle_up")
		2: animated_sprite.play("idle_down")
		3: animated_sprite.play("idle_right")
		4: animated_sprite.play("idle_left")
		_: animated_sprite.play("idle_down")

func _handle_use_state():
	# Handle item usage logic
	SignalBus.use_item.emit()
	

func _initialize_player():
	_reset_stats()
	if PlayerProperties.holdingStats:
		_apply_saved_properties()

func _reset_stats():
	health_manager.max_health = 100
	stats.max_stamina = 200
	health_manager.full_heal()
	stats.full_stamina_restore()

func _apply_saved_properties():
	health_manager.cur_health = PlayerProperties.cur_health
	stats.cur_stamina = PlayerProperties.cur_stamina
	health_manager.max_health = PlayerProperties.max_health
	stats.max_stamina = PlayerProperties.max_stamina
	_apply_skill_levels()

func _apply_skill_levels():
	for skill_name in PlayerProperties.get_skill_names():
		leveling_manager.setSkillLevel(PlayerProperties[skill_name], skill_name)

func _on_health_manager_death():
	print("Deadge")

func levelup(): # on level up increase max health by 2, and stamina by 3.
	health_manager.increase_max_health(2)
	health_manager.full_heal()
	stats.increase_max_stamina(3)
	stats.full_stamina_restore()
	SignalBus.update_max_stats.emit(health_manager.max_health + 2, stats.max_stamina + 3)

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
	match state["last_direction"]:
		1: return self.position - Vector2(0, 20)
		2: return self.position + Vector2(0, 30)
		3: return self.position + Vector2(30, 0)
		4: return self.position - Vector2(30, 0)
		_: return self.position + Vector2(0, 30)

func harvest(toolType: String, toolStrength: int, tool_damage: int) -> void:
	Global.can_harvest = false
	play_harvest_animation(toolType)
	toolType = toolType
	toolStrength = toolStrength
	toolDamage = tool_damage
	
	SignalBus.request_harvest.emit(toolType, toolStrength, tool_damage)
	#player_state = Util.PLAYER_STATES.MOVE  # Reset back to MOVE after using

func play_harvest_animation(toolType: String) -> void:
	match toolType:
		"Pickaxe":
			match state["last_direction"]:
				1: animated_sprite.play("axe_swing_up")
				2: animated_sprite.play("axe_swing_down")
				3: animated_sprite.play("axe_swing_right")
				4: animated_sprite.play("axe_swing_left")
				_: animated_sprite.play("axe_swing_down")
		"Axe": 
			match state["last_direction"]:
				1: animated_sprite.play("axe_swing_up")
				2: animated_sprite.play("axe_swing_down")
				3: animated_sprite.play("axe_swing_right")
				4: animated_sprite.play("axe_swing_left")
				_: animated_sprite.play("axe_swing_down")


func _on_game_state_changed(new_state):
	if new_state == Util.GAME_TIME_STATES.PLAY:
		state["current_speed"] = WALKSPEED


func _on_animated_sprite_2d_animation_finished() -> void:
	if player_state == Util.PLAYER_STATES.USE:
		if toolType and toolStrength and toolDamage:
			SignalBus.request_harvest.emit(toolType, toolStrength, toolDamage)
			toolType = ""
			toolStrength = 0
			toolDamage = 0
		player_state = Util.PLAYER_STATES.MOVE  # Reset back to MOVE after using
		Global.can_harvest = true
