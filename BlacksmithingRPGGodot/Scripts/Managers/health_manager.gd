extends Node

var curHealth = 0
@export var maxHealth: int

signal takenDamage
signal death

func heal(healthToHeal: int): # Heal a specified amount of health, also prevents overflow healing
	print("healing")
	if curHealth + healthToHeal >= maxHealth: # if this heal would heal to above max health restrict it to max
		curHealth = maxHealth
	else:
		curHealth += healthToHeal

func damage(damageDealt: int): # Deal a specified amount of damage, also checked for death and emits a signal
	pass
	if (curHealth - damageDealt) <= 0: # if this damage would reduce health to 0 
		curHealth = 0
		death.emit()
		print("dies of cringe")
	else: 
		curHealth -= damageDealt
		takenDamage.emit()

func setHealth(healthNewNum: int): # Set current health to any specified number
	curHealth = healthNewNum

func fullHeal(): # Heal to max health
	curHealth = maxHealth
	print("Full Heal")

func setMaxHealth(maxHealthNewNum: int): # Set max health to a specified number
	maxHealth = maxHealthNewNum

func increaseMaxHealth(maxHealthIncrease: int): # Set max health to a specified number
	maxHealth += maxHealthIncrease
