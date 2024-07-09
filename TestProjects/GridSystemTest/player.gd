extends CharacterBody2D

var interaction_range = 2

const WALKSPEED = 50.00

var horizontal
var vertical

func _physics_process(delta: float) -> void:
# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	horizontal = Input.get_axis("walk_left", "walk_right")
	vertical = Input.get_axis("walk_up", "walk_down")
	
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
		velocity.x = move_toward(velocity.x, 0,WALKSPEED)
		velocity.y = move_toward(velocity.y, 0, WALKSPEED)
	
	move_and_slide()
