extends CharacterBody2D

var isPaused: bool = false

const RUNSPEED = 140.00
const WALKSPEED = 100.00

var isSprinting = false
var toggleSprint = true

var isInteracting = false

var horizontal
var vertical
var lastDirection

func _ready():
	isPaused = false

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
	
	if not isPaused:
		move_and_slide()
		recieve_inputs()


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
