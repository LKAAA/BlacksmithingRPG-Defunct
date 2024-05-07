extends CharacterBody2D

const RUNSPEED = 80.00
const WALKSPEED = 50.00

var isSprinting = false
var toggleSprint = true

var isInteracting = false

var horizontal
var vertical
var lastDirection

@onready var leveling_manager = $LevelingManager
@onready var health_manager = $HealthManager
@onready var interactionManager = $InteractionManager
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	health_manager.fullHeal()

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
	
	
	if Input.is_action_just_pressed("OpenInventory"):
		# var foundItem = ItemDatabase.get_item("Plant")
		# print(foundItem.value)
		# print(foundItem.name)
		# print(foundItem.description)
		
		# health_manager.damage(10)
		# print("Taken 10 damage.")
		
		leveling_manager.gainXP(500, "Mining")
		pass
	
	if Input.is_action_just_pressed("interact"):
		print("init interaction")
		leveling_manager.gainXP(500, "Combat")
		interactionManager.initiate_interaction()

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
