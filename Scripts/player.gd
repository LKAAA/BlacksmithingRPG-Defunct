extends CharacterBody2D

const SPEED = 80.00

var isInteracting = false

var horizontal
var vertical
var lastDirection

@onready var interactionManager = $InteractionManager

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	horizontal = Input.get_axis("walk_left", "walk_right")
	vertical = Input.get_axis("walk_up", "walk_down")
	
	# First check if you are moving in both direction
	if vertical && horizontal: # If you are moving in both direction cap speed at half so it doesnt move at double move speed diagonally
		velocity.x = horizontal * SPEED
		velocity.y = vertical * SPEED
	elif horizontal: # If only moving horizontal you want to slow down vertical to 0
		velocity.x = horizontal * SPEED
		velocity.y = move_toward(velocity.y, 0, SPEED)
	elif vertical: # Same but with vertical and horizontal
		velocity.y = vertical * SPEED
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
	play_animations()
	
	if Input.is_action_just_pressed("interact"):
		print("init interaction")
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
